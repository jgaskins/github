require "./resource"
require "./account"

module GitHub
  module RefProperties
    getter sha : String
    getter url : URI
  end

  struct Ref
    include Resource

    getter ref : String
    getter node_id : String
    getter url : URI
    getter object : Object

    struct Object
      include Resource
      getter type : String
      getter sha : String
      getter url : URI
    end
  end

  struct CommitEntry
    include Resource
    include RefProperties

    getter html_url : URI?
  end

  struct CommitDetail
    include Resource
    include RefProperties

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
    include JSON::Serializable::Unmapped

    getter! sha : String
    getter! message : String
    getter! ref : String
    # getter node_id : String
    # getter url : URI
    getter! author : Actor
    getter! committer : Actor
    getter! tree : CommitEntry
    getter! parents : Array(CommitEntry)
    # getter verification : Verification
    # getter html_url : URI
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
