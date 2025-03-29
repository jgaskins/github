require "./repos"
require "./environment"

module GitHub
  struct Repo
    def environments
      Environments.new(client, owner, name)
    end
  end

  struct Environments < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def list
      client.get "/repos/#{repo_owner}/#{repo_name}/environments", as: ListResponse
    end

    struct ListResponse
      include Resource

      getter total_count : Int64
      getter environments : Array(Environment)
    end
  end
end
