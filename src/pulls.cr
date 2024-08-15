require "./api"
require "./commit"
require "./pull_request"

module GitHub
  struct Pulls < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end
  end

  struct Pull < API
    getter repo_owner : String
    getter repo_name : String
    getter number : Int64

    def initialize(client, @repo_owner, @repo_name, @number)
      super client
    end

    def get
      get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}",
        as: PullRequest
    end

    def commits
      get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}/commits",
        as: Array(CommitDetail)
    end

    def comments
      Comments.new(client, repo_owner, repo_name, number)
    end

    struct Comments < API
      getter repo_owner : String
      getter repo_name : String
      getter number : Int64

      def initialize(client, @repo_owner, @repo_name, @number)
        super client
      end

      def create(body : String)
        post "/repos/#{@repo_owner}/#{@repo_name}/issues/#{@number}/comments",
          {body: body}.to_json,
          as: JSON::Any
      end
    end
  end
end
