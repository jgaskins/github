require "./resource"
require "./repository"
require "./issue"
require "./account"
require "./organization"
require "./issue_comment"
require "./pull_request"
require "./check_run"

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

      use_json_discriminator "action", {
        created:  Created,
        opened:   Opened,
        closed:   Closed,
        edited:   Edited,
        reopened: Reopened,
      }

      action Created
      action Opened
      action Closed
      action Reopened
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

      use_json_discriminator "action", {
        created: Created,
        deleted: Deleted,
      }

      getter issue : Issue
      getter comment : ::GitHub::IssueComment
      getter repository : Repository
      getter organization : Organization
      getter sender : Account
      getter installation : InstallationID

      struct Created < self
      end

      struct Deleted < self
      end
    end

    define PullRequest do
      use_json_discriminator "action", {
        created: Created,
        closed:  Closed,
      }

      struct Created < self
      end

      struct Closed < self
      end
    end

    define PullRequestReview do
      register "pull_request_review"

      use_json_discriminator "action", {
        dismissed: Dismissed,
        edited:    Edited,
        submitted: Submitted,
        deleted:   Deleted,
      }

      getter installation : GitHub::InstallationID
      getter organization : GitHub::Organization
      getter pull_request : GitHub::PullRequest
      getter repository : GitHub::Repository
      getter review : GitHub::PullRequest::Review
      getter sender : GitHub::Account

      action Dismissed do
      end

      action Edited do
      end

      action Submitted do
      end

      action Deleted do
      end
    end

    define PullRequestReviewComment do
      register "pull_request_review_comment"

      use_json_discriminator "action", {
        created: Created,
        deleted: Deleted,
      }

      getter action : String
      getter comment : ::GitHub::PullRequest::Review::Comment
      getter pull_request : GitHub::PullRequest
      getter repository : GitHub::Repository
      getter organization : GitHub::Organization
      getter sender : GitHub::Account
      getter installation : GitHub::InstallationID

      action Created do
      end

      action Deleted do
      end
    end

    define Installation do
      register "installation"

      getter action : String
      getter installation : GitHub::Installation

      use_json_discriminator "action", {
        created:                  Created,
        new_permissions_accepted: NewPermissionsAccepted,
      }

      struct Created < self
      end

      struct NewPermissionsAccepted < self
      end
    end

    define InstallationRepositories do
      register "installation_repositories"

      use_json_discriminator "action", {
        added:   Added,
        removed: Removed,
      }

      action Added
      action Removed
    end

    define CheckRun do
      register "check_run"

      getter action : String
      getter check_run : GitHub::CheckRun
      getter installation : GitHub::InstallationID
      getter organization : GitHub::Organization
      getter repository : GitHub::Repository
      getter sender : GitHub::Account

      use_json_discriminator "action", {
        completed:        Completed,
        created:          Created,
        requested_action: RequestedAction,
        rerequested:      Rerequested,
      }

      action Completed
      action Created
      action RequestedAction do
        getter requested_action : RequestedAction

        struct RequestedAction
          include Resource
          getter identifier : String?
        end
      end
      action Rerequested
    end

    define CheckSuite do
      register "check_suite"

      getter action : String
      getter check_suite : GitHub::CheckSuite
      getter repository : GitHub::Repository
      getter organization : GitHub::Organization
      getter sender : GitHub::Account
      getter installation : GitHub::InstallationID

      use_json_discriminator "action", {
        created:     Created,
        completed:   Completed,
        rerequested: Rerequested,
      }

      action Created
      action Completed
      action Rerequested
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
