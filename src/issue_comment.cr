require "./resource"
require "./account"
require "./author_association"

struct GitHub::IssueComment
  include Resource

  getter id : Int64
  getter node_id : String
  getter user : Account
  getter created_at : Time
  getter updated_at : Time
  getter author_association : AuthorAssociation
  getter body : String { body_html }
  getter! body_html : String
  getter reactions : Reactions

  struct Reactions
    include Resource

    getter url : URI
    getter total_count : Int64
    @[JSON::Field(key: "+1")]
    getter thumbs_up : Int64
    @[JSON::Field(key: "-1")]
    getter thumbs_down : Int64
    getter laugh : Int64
    getter hooray : Int64
    getter confused : Int64
    getter heart : Int64
    getter rocket : Int64
    getter eyes : Int64
  end
end
