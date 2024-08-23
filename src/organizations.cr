require "./api"
require "./organization"

module GitHub
  class Client
    def organizations
      Organizations.new self
    end

    def user_orgs
      Organizations::ForUser.new self
    end
  end

  struct Organizations < API
    def list
      get "/organizations", as: Array(ListItem)
    end

    struct ForUser < API
      def list
        get "/user/orgs", as: Array(ListItem)
      end
    end

    struct ListItem
      include Resource

      getter id : Int64
      getter login : String
      getter node_id : String
      getter url : URI
      getter repos_url : URI
      getter events_url : URI
      getter hooks_url : URI
      getter issues_url : URI
      getter members_url : URI
      getter public_members_url : URI
      getter avatar_url : URI
      getter description : String?
    end
  end

  struct OrganizationAPI < API
    getter organization : Organization

    def initialize(client, @organization)
      super client
    end

    def outside_collaborators
      OutsideCollaborators.new(client, @organization)
    end

    struct OutsideCollaborators < API
      getter organization : Organization

      def initialize(client, @organization)
        super client
      end

      def add(username : String)
        client.put "/orgs/#{organization.login}/outside_collaborators/#{username}", as: JSON::Any
      end
    end
  end
end
