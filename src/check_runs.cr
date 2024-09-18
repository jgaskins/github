require "./api"
require "./check_run"
require "./repos"

module GitHub
  struct CheckRunAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter check_run_id : Int64

    def initialize(client, @repo_owner, @repo_name, @check_run_id)
      super client
    end

    def get
      get "/repos/#{repo_owner}/#{repo_name}/check-runs/#{check_run_id}", as: CheckRun
    end

    def annotations
      Annotations.new client, repo_owner, repo_name, check_run_id
    end

    struct Annotations < API
      getter repo_owner : String
      getter repo_name : String
      getter check_run_id : Int64

      def initialize(client, @repo_owner, @repo_name, @check_run_id)
        super client
      end

      def list
        get "/repos/#{repo_owner}/#{repo_name}/check-runs/#{check_run_id}/annotations",
          as: Array(CheckRun::Annotation)
      end
    end
  end

  abstract struct CheckRuns < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def list(
      page : Int32? = nil,
      per_page : Int32? = nil,
      filter : Filter? = nil,
      status : Status? = nil,
      check_name : String? = nil,
      app_id : Int64? = nil
    ) : CheckRunList
      params = URI::Params.new
      if page
        params["page"] = page.to_s
      end

      if per_page
        params["per_page"] = per_page.to_s
      end

      if filter
        params["filter"] = filter.to_s
      end

      if check_name
        params["check_name"] = check_name
      end

      if status
        params["status"] = status.to_s
      end

      if app_id
        params["app_id"] = app_id.to_s
      end

      get "/repos/#{repo_owner}/#{repo_name}#{scope}/check-runs?#{params}",
        as: CheckRunList
    end

    enum Filter
      Latest
      All

      def to_s
        case self
        in .latest?
          "latest"
        in .all?
          "all"
        end
      end
    end

    enum Status
      Queued
      InProgress
      Completed

      def to_s
        case self
        in .queued?
          "queued"
        in .in_progress?
          "in_progress"
        in .completed?
          "completed"
        end
      end
    end
  end

  struct CheckRunsForRef < CheckRuns
    def initialize(client, repo_owner, repo_name, @ref : String)
      super client, repo_owner, repo_name
    end

    def scope
      "/commits/#{@ref}"
    end
  end

  struct CheckRunsForCheckSuite < CheckRuns
    def initialize(client, repo_owner, repo_name, @check_suite_id : Int64)
      super client, repo_owner, repo_name
    end

    def scope
      "/check-suites/#{@check_suite_id}"
    end
  end

  struct Repo < API
    def check_run(id : Int64)
      CheckRunAPI.new client, owner, name, id
    end
  end
end
