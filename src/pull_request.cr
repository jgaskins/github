require "./resource"

module GitHub
  struct PullRequest
    include Resource

    getter url : URI
    getter id : Int64
    getter number : Int64
    getter head : Commit
    getter base : Commit
  end

  struct PullRequestListEntry
    include Resource
    include JSON::Serializable::Unmapped

    getter url : URI
    getter id : Int64
    getter number : Int64
    getter head : CommitEntry
    getter base : CommitEntry
  end
end
