require "oauth2"
require "jwt"
require "json"
require "openssl/hmac"
require "crypto/subtle"

require "./api"
require "./client"
require "./installation"
require "./webhook"
require "./event"
require "./private_key"

module GitHub
  class App
    # GitHub shouldn't be sending webhooks over 1MB, right?
    private MAX_WEBHOOK_BYTES = 1 << 20

    getter id : Int64
    getter client_id : String
    getter redirect_uri : String?
    @client_secret : String
    @private_key : String

    def initialize(
      *,
      @id = ENV["GITHUB_APP_ID"].to_i64,
      @client_id = ENV["GITHUB_CLIENT_ID"],
      @client_secret = ENV["GITHUB_CLIENT_SECRET"],
      private_key : String = ENV.fetch("GITHUB_PRIVATE_KEY") { ENV["GITHUB_PRIVATE_KEY_FILE"] },
      @redirect_uri = ENV["GITHUB_OAUTH2_REDIRECT_URI"]?,
    )
      @private_key = PrivateKey.load(private_key)
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

    def webhook(request : ::HTTP::Request, webhook_secret : String) : Webhook?
      body = request.body
      event_type = request.headers["X-Github-Event"]?
      signature = request.headers["X-Hub-Signature-256"]?.try(&.lchop("sha256="))
      id = request.headers["X-Github-Hook-ID"]?.try(&.to_i64?)
      delivery = request.headers["X-Github-Delivery"]?
      installation_target_type = request.headers["X-Github-Hook-Installation-Target-Type"]?
      installation_target_id = request.headers["X-Github-Hook-Installation-Target-ID"]?.try(&.to_i64?)

      if body && event_type && signature && id && delivery && installation_target_type && installation_target_id
        if body = body.gets(limit: MAX_WEBHOOK_BYTES)
          expected_signature = OpenSSL::HMAC.hexdigest(:sha256, webhook_secret, body)
          unless Crypto::Subtle.constant_time_compare(expected_signature, signature)
            return nil
          end

          Webhook.new(
            id: id,
            delivery: delivery,
            type: event_type,
            installation_target_type: installation_target_type,
            installation_target_id: installation_target_id,
            event: Event[event_type, body],
          )
        end
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
        redirect_uri: @redirect_uri,
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
        @issuer = nil,
      )
      end
    end
  end
end
