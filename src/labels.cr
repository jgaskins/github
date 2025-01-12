require "./api"
# require "./label"
require "./pulls"

module GitHub
  struct Labels < API
    getter repo_owner : String
    getter repo_name : String
    getter pull_number : Int64

    def self.new(pull : Pull)
      new pull.client, pull.repo_owner, pull.repo_name, pull.number
    end

    def initialize(client, @repo_owner, @repo_name, @pull_number)
      super client
    end

    def list
      client.get "/repos/#{repo_full_name}/pulls/#{pull_number}/labels", as: JSON::Any
    end

    def repo_full_name
      "#{repo_owner}/#{repo_name}"
    end
  end

  struct Repo
    def labels
      Labels.new self
    end
  end
end
