require "./api"
require "./issue"

module GitHub
  struct Issues < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def list(
      filter : Filter? = nil
    ) : Array(Issue)
      params = URI::Params{
        "filter" => filter.to_s,
      }
      get "/repos/#{repo_owner}/#{repo_name}/issues?#{params}", as: Array(Issue)
    end

    enum Filter
      Assigned
      Created
      Mentioned
      Subscribed
      Repos
      All
    end
  end

  struct AssignedIssues < API
    def list
      get "/issues", as: Array(Issue)
    end
  end

  class Client
    def issues
      AssignedIssues.new self
    end
  end
end
