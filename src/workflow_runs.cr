require "compress/zip"

require "./api"
require "./workflow_run"
require "./repos"

module GitHub
  struct WorkflowRunAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter id : Int64

    def initialize(client, @repo_owner, @repo_name, workflow_run_id @id)
      super client
    end

    def get
      get "/repos/#{repo_full_name}/actions/runs/#{id}", as: WorkflowRun
    end

    def logs
      response = get "/repos/#{repo_full_name}/actions/runs/#{id}/logs"
      if response.status.redirection?
        HTTP::Client.get response.headers["location"] do |response|
          Compress::Zip::Reader.open response.body_io do |zip|
            yield zip
          end
        end
      else
        raise RequestError.new("#{response.status}")
      end
    end

    private def repo_full_name
      "#{repo_owner}/#{repo_name}"
    end
  end

  struct Repo
    def workflow_run(id : Int64)
      WorkflowRunAPI.new client, owner, name, id
    end
  end
end
