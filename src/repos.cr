require "./api"
require "./branches"

module GitHub
  struct Repo < API
    getter owner : String
    getter name : String

    def initialize(client, @owner, @name)
      super client
    end

    def branches
      Branches.new(client, owner, name)
    end
  end

  struct Repos < API
    getter owner : String

    def initialize(client, @owner)
      super client
    end
  end

  class Client
    def repo(owner : String, name : String)
      Repo.new(self, owner, name)
    end

    def repos(owner : String)
      Repos.new(self, owner)
    end
  end
end
