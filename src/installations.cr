require "./api"


module GitHub
  struct Installations < API
    def list
      get "/app/installations", as: Array(Installation)
    end
  end

  class Client
    def installations
      Installations.new self
    end
  end
end