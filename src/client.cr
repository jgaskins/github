require "http"
require "db/pool"

require "./error"
require "./resource"
require "./graphql"
require "./account"
require "./version"

module GitHub
  class Client
    getter token : -> String
    getter rate_limits : Hash(String, RateLimit) do
      Hash(String, RateLimit).new do |hash, resource|
        hash[resource] = RateLimit.new(resource: resource)
      end
    end
    private getter base_uri : URI

    def self.new(token : String = ENV["GITHUB_API_TOKEN"], base_uri : URI = URI.parse("https://api.github.com"))
      new(base_uri) { token }
    end

    def initialize(
      @base_uri = URI.parse("https://api.github.com"),
      &@token : -> String
    )
      @pool = DB::Pool(HTTP).new(DB::Pool::Options.new(initial_pool_size: 0, max_idle_pool_size: 25)) do
        http = HTTP.new(base_uri)
        http.before_request do |request|
          request.headers["Accept"] ||= "application/vnd.github+json"
          request.headers["Connection"] = "keep-alive"
          request.headers["User-Agent"] = "https://github.com/jgaskins/github (#{VERSION})"
        end
        http
      end
    end

    def user
      get "/user", as: Account
    end

    def user_installations
      get "/user/installations", as: Installation::List
    end

    def graphql
      GraphQL::Client.new(self)
    end

    def get?(path : String, body : String? = nil, *, as type : T.class) : T? forall T
      response = @pool.checkout &.get(path, body: body, headers: default_headers)
      case response.status
      when .success?
        T.from_json response.body
      when .not_found?
        nil
      else
        raise RequestError.new("Unexpected response from `GET #{path}`: #{response.status} #{response.status.code}")
      end
    end

    {% for method in %w[get post put patch delete] %}
      def http_{{method.id}}(path : String, headers : ::HTTP::Headers? = nil, body : String? = nil, &block : ::HTTP::Client::Response -> T) forall T
        if headers
          headers = default_headers.merge!(headers)
        else
          headers = default_headers
        end

        @pool.checkout &.{{method.id}}(path, body: body, headers: headers) do |response|
          if response.status.redirection? && (location = response.headers["location"]?)
            if URI.parse(location).host == @base_uri.host
              http_get(location, headers, body, &block)
            else
              ::HTTP::Client.get(location, headers, body, &block)
            end
          else
            block.call response
          end
        end
      end

      def {{method.id}}(path : String, body : String? = nil, headers : ::HTTP::Headers? = nil, *, as type : T.class) : T forall T
        response = @pool.checkout &.{{method.id}}(path, body: body, headers: headers(headers))
        response = handle response, body

        T.from_json response.body
      end

      def {{method.id}}(path : String, body : String? = nil, headers : ::HTTP::Headers? = nil) : ::HTTP::Client::Response
        response = @pool.checkout &.{{method.id}}(path, body: body, headers: headers(headers))
        handle response, body
      end
    {% end %}

    private def headers(headers : ::HTTP::Headers)
      default_headers.merge!(headers)
    end

    private def headers(no_headers : Nil)
      default_headers
    end

    private def default_headers
      ::HTTP::Headers{"Authorization" => "Bearer #{token.call}"}
    end

    private def handle(response : ::HTTP::Client::Response, body) : ::HTTP::Client::Response
      headers = response.headers
      unless headers.has_key? "X-RateLimit-Limit"
        return response
      end

      resource = headers["X-RateLimit-Resource"]

      rate_limit = rate_limits[resource]

      rate_limit.limit = headers["X-RateLimit-Limit"].to_i
      rate_limit.remaining = headers["X-RateLimit-Remaining"].to_i
      rate_limit.used = headers["X-RateLimit-Used"].to_i
      rate_limit.reset = Time.unix headers["X-RateLimit-Reset"].to_i

      case response.status
      when .success?, .redirection?
        response
      else
        error! response
      end
    end

    private def error!(response)
      error_response = ErrorResponse.from_json(response.body)
      if uri = error_response.documentation_url
        msg = "#{error_response.message} - #{uri}"
      else
        msg = error_response.message
      end
      raise RequestError.new("#{response.status.code} #{response.status} #{response.body}")
    end

    def fetch_rate_limits : Hash(String, RateLimit)
      @rate_limits = get("/rate_limit", as: RateLimitResponse).resources
    end

    private struct RateLimitResponse
      include GitHub::Resource
      getter resources : Hash(String, GitHub::RateLimit)
      getter rate : GitHub::RateLimit
    end

    private struct ErrorResponse
      include Resource

      getter message : String
      getter documentation_url : URI?
    end

    class HTTP < ::HTTP::Client
      @log = ::Log.for("github.client")

      def around_exec(request : ::HTTP::Request)
        start = Time.monotonic
        begin
          yield
        ensure
          @log.debug &.emit "request",
            method: request.method,
            host: request.headers["Host"]?,
            resource: request.resource,
            duration_ms: (Time.monotonic - start).total_milliseconds
        end
      end
    end
  end

  class RateLimit
    include Resource

    getter limit : Int64
    protected setter limit

    getter remaining : Int64
    protected setter remaining

    @[JSON::Field(converter: Time::EpochConverter)]
    getter reset : Time
    protected setter reset

    getter resource : String { "" }
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
      # {"limit" => 1750, "used" => 0, "remaining" => 1750, "reset" => 1711470108}
    end

    def time_until_reset : Time::Span
      @reset - Time.utc
    end
  end
end
