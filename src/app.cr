require "oauth2"

require "./api"

module GitHub
  class App
    getter id : String
    @client_id : String
    @client_secret : String

    def initialize(*, @id, @client_id, @client_secret)
    end

    def get_access_token(code : String)
      token = oauth.get_access_token_using_authorization_code(code)
    end

    def refresh_access_token(refresh_token : String)
      token = oauth.get_access_token_using_refresh_token(refresh_token)
    end

    def authorize_uri : URI
      URI.parse oauth.get_authorize_uri
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
  end
end
