require "./branch"

module GitHub
  struct Branches < API
    getter repo_owner : String
    getter repo : String

    def initialize(client, @repo_owner, @repo)
      super client
    end

    def list
      get "/repos/#{@repo_owner}/#{@repo}/branches", as: Array(BranchSummary)
    end

    def get(name : String)
      get "/repos/#{@repo_owner}/#{@repo}/branches/#{name}", as: BranchDetail
    end
  end
end
