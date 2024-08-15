require "./spec_helper"
require "openssl_ext"

require "../src/app"

describe GitHub::App do
  it "generates JWTs" do
    pkey_file = "spec/support/rsa.key"
    app = GitHub::App.new(
      id: "asdf",
      client_id: "fake-id",
      client_secret: "fake-secret",
      private_key_file: pkey_file,
    )
    now = Time.utc

    jwt = app.jwt

    jwt.should eq JWT.encode(
      {
        iat: now.to_unix,
        exp: (now + 10.minutes).to_unix,
        iss: "asdf",
      },
      File.read(pkey_file),
      :rs256,
    )
  end
end
