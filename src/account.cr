require "./resource"

module GitHub
  struct Account
    include Resource

    getter login : String
    getter id : Int64
    getter node_id : String
    getter name : String { login }
    getter email : String?
    getter avatar_url : URI
    getter gravatar_id : String
    getter url : URI
    getter html_url : URI
    getter followers_url : URI
    getter following_url : URI
    getter gists_url : URI
    getter starred_url : URI
    getter subscriptions_url : URI
    getter organizations_url : URI
    getter repos_url : URI
    getter events_url : URI
    getter received_events_url : URI
    getter type : String
    getter? site_admin : Bool
  end
end
