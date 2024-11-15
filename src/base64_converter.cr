require "base64"

module GitHub::Base64Converter
  extend self

  def from_json(json : ::JSON::PullParser) : String
    Base64.decode_string json.read_string
  end
end
