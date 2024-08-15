require "./api"
require "./check_run"

module GitHub
  struct CheckRuns < API
    getter repo_owner : String
    getter repo_name : String
    getter ref : String

    def initialize(client, @repo_owner, @repo_name, @ref)
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

      get "/repos/#{repo_owner}/#{repo_name}/commits/#{ref}/check-runs?#{params}",
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
end
