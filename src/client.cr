require "http"
require "db/pool"

require "./error"
require "./resource"
require "./graphql"
require "./user"
require "./version"

module GitHub
  class Client
    getter token : String
    getter rate_limits = Hash(String, RateLimit).new { |h, k| h[k] = RateLimit.new(resource: k) }
    private getter base_uri : URI

    def initialize(@token = ENV["GITHUB_API_TOKEN"], @base_uri = URI.parse("https://api.github.com"))
      authorization = "Bearer #{token}"
      @pool = DB::Pool(HTTP).new do
        http = HTTP.new(base_uri)
        http.before_request do |request|
          request.headers["Authorization"] = authorization
          request.headers["Accept"] = "application/vnd.github+json"
          request.headers["Connection"] = "keep-alive"
          request.headers["User-Agent"] = "https://github.com/jgaskins/github (#{VERSION})"
        end
        http
      end
    end

    def user
      get "/user", as: User
    end

    def graphql
      GraphQL::Client.new(self)
    end

    def get(path : String, as type : T.class) : T forall T
      response = @pool.checkout &.get(path)
      handle response

      if response.success?
        T.from_json response.body
      else
        error_response = ErrorResponse.from_json(response.body)
        if uri = error_response.documentation_url
          msg = "#{error_response.message} - #{uri}"
        else
          msg = error_response.message
        end
        raise RequestError.new(msg)
      end
    end

    def post(path : String, body : String, as type : T.class) : T forall T
      response = @pool.checkout &.post(path, body: body)
      handle response

      if response.success?
        T.from_json response.body
      else
        error_response = ErrorResponse.from_json(response.body)
        if uri = error_response.documentation_url
          msg = "#{error_response.message} - #{uri}"
        else
          msg = error_response.message
        end
        raise RequestError.new(msg)
      end
    end

    private def handle(response : ::HTTP::Client::Response) : Nil
      headers = response.headers

      rate_limit = rate_limits[headers["X-RateLimit-Resource"]]

      rate_limit.limit = headers["X-RateLimit-Limit"].to_i
      rate_limit.remaining = headers["X-RateLimit-Remaining"].to_i
      rate_limit.used = headers["X-RateLimit-Used"].to_i
      rate_limit.reset = Time.unix headers["X-RateLimit-Reset"].to_i
    end

    private struct ErrorResponse
      include Resource

      getter message : String
      getter documentation_url : URI?
    end

    class HTTP < ::HTTP::Client
    end
  end

  class RateLimit
    getter limit : Int64
    protected setter limit

    getter remaining : Int64
    protected setter remaining

    getter reset : Time
    protected setter reset

    getter resource : String
    protected setter resource

    getter used : Int64
    protected setter used

    def initialize(
      *,
      @resource,
      @limit = 0,
      @remaining = 0,
      @used = 0,
      @reset = Time.utc
    )
    end

    def time_until_reset : Time::Span
      @reset - Time.utc
    end
  end
end
