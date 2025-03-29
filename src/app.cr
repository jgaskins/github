require "oauth2"
require "jwt"
require "json"

require "./api"
require "./client"
require "./installation"

module GitHub
  class App
    #
    getter id : Int64
    @client_id : String
    @client_secret : String
    @private_key : String

    def initialize(
      *,
      @id = ENV["GITHUB_APP_ID"].to_i64,
      @client_id = ENV["GITHUB_CLIENT_ID"],
      @client_secret = ENV["GITHUB_CLIENT_SECRET"],
      private_key_file : String = ENV["GITHUB_PRIVATE_KEY_FILE"]
    )
      @private_key = File.read(private_key_file)
    end

    def get_access_token(code : String)
      oauth.get_access_token_using_authorization_code(code)
    end

    def refresh_access_token(refresh_token : String)
      oauth.get_access_token_using_refresh_token(refresh_token)
    end

    def authorize_uri : URI
      URI.parse oauth.get_authorize_uri
    end

    getter client : Client do
      Client.new { jwt }
    end

    def jwt(now : Time = Time.utc)
      payload = Payload.new(
        issued_at: now - 1.minute,
        expires_at: now + 10.minutes,
        issuer: id,
      )
      JWT.encode payload, @private_key, :rs256
    end

    def installations : Array(Installation)
      client.get "/app/installations", as: Array(Installation)
    end

    def installation_client(installation_id : Int64)
      token = installation_token(installation_id)

      Client.new do
        if token.expired?
          token = installation_token(installation_id)
        end

        token.token
      end
    end

    def user_client(access_token : String) : Client
      Client.new { access_token }
    end

    def installation_token(installation_id : Int64) : InstallationToken
      client.post "/app/installations/#{installation_id}/access_tokens",
        body: "",
        as: InstallationToken
    end

    private getter oauth : OAuth2::Client do
      OAuth2::Client.new(
        host: "github.com",
        client_id: @client_id,
        client_secret: @client_secret,
        authorize_uri: "/login/oauth/authorize",
        token_uri: "/login/oauth/access_token",
      )
    end

    struct Payload
      include JSON::Serializable
      @[JSON::Field(key: "iat", converter: Time::EpochConverter)]
      getter issued_at : Time
      @[JSON::Field(key: "exp", converter: Time::EpochConverter)]
      getter expires_at : Time?
      @[JSON::Field(key: "iss")]
      getter issuer : Int64?

      def initialize(
        *,
        @issued_at = Time.utc,
        @expires_at = nil,
        @issuer = nil
      )
      end
    end
  end
end
