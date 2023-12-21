require "oauth2"

require "./api"

module GitHub
  class App
    @client_id : String
    @client_secret : String

    def initialize(@client_id, @client_secret)
    end

    def get_access_token(code : String)
      token = oauth.get_access_token_using_authorization_code(code)
    end

    private def oauth
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
