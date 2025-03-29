require "./resource"

module GitHub
  struct Team
    include Resource

    getter id : Int64
    getter node_id : String
    getter name : String
    getter slug : String
    getter description : String?
    getter privacy : String
    getter permission : String
    getter permissions : Permissions
    getter html_url : String
    getter parent : Parent?


    struct Permissions
      include Resource

      getter? pull : Bool
      getter? triage : Bool
      getter? push : Bool
      getter? maintain : Bool
      getter? admin : Bool
    end

    struct Parent
      include Resource

      getter id : Int64
      getter node_id : String
      getter name : String
      getter description : String?
      getter privacy : String
      getter notification_setting : String?
      getter html_url : String
      getter slug : String
    end
  end
end
