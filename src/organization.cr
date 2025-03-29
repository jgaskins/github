require "./resource"

struct GitHub::Organization
  include Resource

  getter id : Int64
  getter login : String
  getter node_id : String
  getter url : URI
  getter avatar_url : URI
  getter description : String?
  getter company : String?
end
