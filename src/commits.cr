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

    def diff
      headers = HTTP::Headers{"accept" => "application/vnd.github.v3.diff"}
      client.http_get "/repos/#{@repo_owner}/#{@repo_name}/commits/#{@ref}", headers: headers do |response|
        if response.success?
          response.body_io.gets_to_end
        else
          raise RequestError.new("#{response.status.code} #{response.status} #{response.body_io.gets_to_end}")
        end
      end
    end

    def check_runs
      CheckRuns.new(client, repo_owner, repo_name, ref)
    end
  end
end
