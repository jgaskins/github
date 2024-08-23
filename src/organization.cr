require "./resource"

struct GitHub::Organization
  include Resource

  getter id : Int64
  getter login : String
  getter node_id : String
  getter url : URI
  getter repos_url : URI
  getter events_url : URI
  getter hooks_url : URI
  getter issues_url : URI
  getter members_url : URI
  getter public_members_url : URI
  getter avatar_url : URI
  getter description : String
  getter company : String?
end
