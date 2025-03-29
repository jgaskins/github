require "./resource"
require "./account"

module GitHub
  struct Deployment
    include Resource

    getter id : Int64
    getter node_id : String
    getter sha : String
    getter ref : String
    getter task : String
    getter payload : JSON::Any
    getter original_environment : String?
    getter environment : String
    getter description : String?
    getter creator : Account
    getter created_at : Time
    getter updated_at : Time
    getter? transient_environment : Bool
    getter? production_environment : Bool

    struct Status
      include Resource

      getter id : Int64
      getter node_id : String
      getter state : State
      getter creator : Account
      getter description : String?
      getter environment : String?
      getter log_url : String?
      getter created_at : Time
      getter updated_at : Time
      getter environment_url : String

      enum State
        Error
        Failure
        Inactive
        InProgress
        Queued
        Pending
        Success
      end
    end
  end
end
