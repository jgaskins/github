require "./resource"

module GitHub
  struct Account
    include Resource

    getter! login : String
    getter id : Int64
    getter node_id : String
    getter name : String { login }
    getter email : String?
    getter avatar_url : URI
    getter gravatar_id : String
    getter url : URI
    getter html_url : URI
    getter type : String
    getter? site_admin : Bool
  end
end
