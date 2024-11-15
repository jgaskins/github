require "./resource"

struct GitHub::Label
  include Resource

  getter id : Int64
  getter node_id : String
  getter url : URI
  getter name : String
  getter color : String
  getter? default : Bool?
  getter description : String?
end
