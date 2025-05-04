require "./resource"
require "./event"

module GitHub
  struct Webhook
    getter id : Int64
    getter delivery : String
    getter type : String
    getter installation_target_type : String?
    getter installation_target_id : Int64?
    getter event : Event

    def initialize(@id, @delivery, @type, @installation_target_type, @installation_target_id, @event)
    end
  end
end
