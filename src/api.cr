require "./client"

module GitHub
  abstract struct API
    getter client : Client

    def initialize(@client)
    end

    delegate get, post, put, patch, delete, to: client
  end
end
