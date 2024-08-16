require "./resource"
require "./account"

module GitHub
  module Ref
    getter sha : String
    getter url : URI
  end

  struct CommitEntry
    include Resource
    include Ref

    getter html_url : URI?
  end

  struct CommitDetail
    include Resource
    include Ref

    getter commit : Commit
    getter node_id : String
    getter html_url : URI
    getter comments_url : URI
    getter author : Account
    getter committer : Account
    getter parents : Array(CommitEntry)
  end

  struct Commit
    include Resource

    getter author : Actor
    getter committer : Actor
    getter message : String
    getter tree : CommitEntry
    getter url : URI
    getter comment_count : Int64
    getter verification : Verification
  end

  struct Actor
    include Resource

    getter name : String
    getter email : String
    getter date : Time
  end

  struct Verification
    include Resource

    getter? verified : Bool
    getter reason : String
    getter signature : String?
    getter payload : String?
  end
end
