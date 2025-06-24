require "./resource"
require "./repository"
require "./issue"
require "./account"
require "./organization"
require "./issue_comment"
require "./pull_request"
require "./check_run"
require "./check_suite"
require "./deployment"

module GitHub
  abstract struct Event
    include Resource
    include JSON::Serializable::Unmapped

    getter action : String

    macro define(type)
      abstract struct ::GitHub::Event::{{type}} < {{@type}}
        {{yield}}
      end
    end

    macro action(type)
      struct {{type}} < {{@type}}
        {{yield}}
      end
    end

    macro actions(**types)
      use_json_discriminator "action", {{types}}

      {% for action, type in types %}
        action {{type}}
      {% end %}
    end

    private TYPE_MAP = {} of String => Event.class

    def self.[](type : String, data : String)
      TYPE_MAP
        .fetch(type) do
          raise UnknownType.new("Unexpected event type #{type.inspect}")
        end
        .from_json(data)
    end

    def self.register(type_name, type : Event.class = self)
      {% if @type == ::GitHub::Event %}
        TYPE_MAP[type_name] = type
      {% else %}
        ::GitHub::Event.register type_name, type
      {% end %}
    end

    use_json_discriminator "type", {
      ping:                      Ping,
      issues:                    Issues,
      installation:              Installation,
      installation_repositories: InstallationRepositories,
    }

    struct Actor
      include Resource
      include JSON::Serializable::Unmapped

      getter id : String
      getter login : String
      getter display_login : String
      getter gravatar_id : String?
      getter url : String?
      getter avatar_url : String?
    end

    struct Ping < self
      register "ping"
    end

    define Issues do
      register "issues"

      getter issue : Issue
      getter repository : Repository
      getter organization : Organization
      getter sender : Account
      getter installation : InstallationID

      actions(
        created: Created,
        opened: Opened,
        closed: Closed,
        edited: Edited,
        reopened: Reopened,
      )

      action Edited do
        getter changes : Hash(String, Change)

        struct Change
          include Resource

          getter from : JSON::Any
        end
      end
    end

    define IssueComment do
      register "issue_comment"

      getter issue : Issue
      getter comment : ::GitHub::IssueComment
      getter repository : Repository
      getter organization : Organization
      getter sender : Account
      getter installation : InstallationID

      actions(
        created: Created,
        deleted: Deleted,
        edited: Edited,
      )
    end

    define PullRequest do
      actions(
        created: Created,
        closed: Closed,
      )
    end

    define PullRequestReview do
      register "pull_request_review"

      getter installation : GitHub::InstallationID
      getter organization : GitHub::Organization
      getter pull_request : GitHub::PullRequest
      getter repository : GitHub::Repository
      getter review : GitHub::PullRequest::Review
      getter sender : GitHub::Account

      actions(
        dismissed: Dismissed,
        edited: Edited,
        submitted: Submitted,
        deleted: Deleted,
      )
    end

    define PullRequestReviewComment do
      register "pull_request_review_comment"

      getter action : String
      getter comment : ::GitHub::PullRequest::Review::Comment
      getter pull_request : GitHub::PullRequest
      getter repository : GitHub::Repository
      getter organization : GitHub::Organization
      getter sender : GitHub::Account
      getter installation : GitHub::InstallationID

      actions(
        created: Created,
        deleted: Deleted,
      )
    end

    define Installation do
      register "installation"

      getter action : String
      getter installation : GitHub::Installation
      getter repositories : Array(Repository)?
      getter sender : GitHub::Account

      def all_repositories?
        repositories.nil?
      end

      actions(
        created: Created,
        deleted: Deleted,
        new_permissions_accepted: NewPermissionsAccepted,
      )

      struct Repository
        include JSON::Serializable

        getter id : Int64
        getter node_id : String
        getter name : String
        getter full_name : String
        getter? private : Bool
      end
    end

    define InstallationRepositories do
      register "installation_repositories"

      actions(
        added: Added,
        removed: Removed,
      )
    end

    define CheckRun do
      register "check_run"

      getter action : String
      getter check_run : GitHub::CheckRun
      getter installation : GitHub::InstallationID
      getter organization : GitHub::Organization
      getter repository : GitHub::Repository
      getter sender : GitHub::Account

      actions(
        completed: Completed,
        created: Created,
        requested_action: RequestedAction,
        rerequested: Rerequested,
      )

      action RequestedAction do
        getter requested_action : RequestedAction

        struct RequestedAction
          include Resource
          getter identifier : String?
        end
      end
    end

    define CheckSuite do
      register "check_suite"

      getter action : String
      getter check_suite : GitHub::CheckSuite
      getter repository : GitHub::Repository
      getter organization : GitHub::Organization
      getter sender : GitHub::Account
      getter installation : GitHub::InstallationID

      actions(
        created: Created,
        completed: Completed,
        rerequested: Rerequested,
      )
    end

    define Deployment do
      include JSON::Serializable::Unmapped
      register "deployment"

      getter deployment : GitHub::Deployment
      getter repository : GitHub::Repository
      getter organization : GitHub::Organization
      getter sender : GitHub::Account
      getter installation : GitHub::InstallationID

      # FIXME: Define types for these
      getter workflow : JSON::Any
      getter workflow_run : JSON::Any

      actions(
        created: Created,
      )
    end

    define DeploymentStatus do
      include JSON::Serializable::Unmapped
      register "deployment_status"

      getter deployment_status : GitHub::Deployment::Status
      getter deployment : GitHub::Deployment
      getter repository : GitHub::Repository
      getter organization : GitHub::Organization
      getter sender : GitHub::Account
      getter installation : GitHub::InstallationID

      # FIXME: Define types for these
      getter check_run : JSON::Any
      getter workflow : JSON::Any
      getter workflow_run : JSON::Any

      actions(
        created: Created,
      )
    end

    class UnknownType < Error
    end
  end

  struct InstallationID
    include Resource

    getter id : Int64
    getter node_id : String
  end
end
