require "./resource"

struct GitHub::Reaction
  include Resource

  getter id : Int64
  getter node_id : String
  getter user : Account
  getter content : Content
  getter created_at : Time

  enum Content
    ThumbsUp
    ThumbsDown
    Laugh
    Confused
    Heart
    Hooray
    Rocket
    Eyes

    def self.new(json : JSON::PullParser)
      case string = json.read_string
      when "+1"
        ThumbsUp
      when "-1"
        ThumbsDown
      else
        parse string
      end
    end

    def to_json(json : JSON::Builder)
      case self
      when ThumbsUp
        json.string "+1"
      when ThumbsDown
        json.string "-1"
      else
        super
      end
    end
  end
end
