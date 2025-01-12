require "./client"

module GitHub
  abstract struct API
    getter client : Client

    def initialize(@client)
    end

    def headers_for(body_type : BodyType)
      case body_type
      in .text?
        ::HTTP::Headers.new
      in .html?
        ::HTTP::Headers{"Accept" => "application/vnd.github.html+json"}
      end
    end

    enum BodyType
      Text
      HTML
    end
  end
end
