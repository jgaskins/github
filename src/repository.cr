module GitHub
  struct Repository
    include Resource
    include JSON::Serializable::Unmapped

    getter id : Int64
    getter node_id : String
    getter name : String
    getter full_name : String
    getter owner : User
    getter? private : Bool
  end
end
