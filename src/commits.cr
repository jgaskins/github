require "./api"
require "./commit"
require "./check_runs"

module GitHub
  struct CommitAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter ref : String

    def initialize(client, @repo_owner, @repo_name, @ref)
      super client
    end

    def check_runs
      CheckRuns.new(client, repo_owner, repo_name, ref)
    end
  end
end
