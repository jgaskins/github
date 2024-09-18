require "./api"
require "./check_suite"
require "./repos"
require "./check_runs"
require "./client"

module GitHub
  struct CheckSuiteAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter check_suite_id : Int64

    def initialize(client, @repo_owner, @repo_name, @check_suite_id)
      super client
    end

    def check_runs
      CheckRunsForCheckSuite.new client, repo_owner, repo_name, check_suite_id
    end
  end

  struct Repo
    def check_suite(check_suite suite : CheckSuite)
      check_suite suite.id
    end

    def check_suite(check_suite_id id : Int64)
      CheckSuiteAPI.new(client, owner, name, id)
    end
  end
end
