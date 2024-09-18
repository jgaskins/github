require "./resource"
require "./commit"
require "./branch_protection"

module GitHub
  struct BranchSummary
    include Resource

    getter name : String
    getter commit : CommitEntry
    getter? protected : Bool
    getter protection : BranchProtection?
    getter protection_url : URI?
  end

  struct Branch
    include Resource

    getter name : String
    getter commit : Commit
    getter? protected : Bool
    getter protection : BranchProtection?
    getter protection_url : URI?

    struct Commit
      include Resource

      getter sha : String
      getter node_id : String
      getter commit : GitCommit
      getter url : URI
      getter html_url : URI
      getter comments_url : URI
      getter author : Account
      getter committer : Account
      getter parents : Array(Tree)

      struct GitCommit
        include Resource

        getter author : Actor
        getter committer : Actor
        getter message : String
        getter tree : Tree
        getter url : String
        getter comment_count : Int64
        getter verification : Verification
      end
    end

    struct Tree
      include Resource

      getter sha : String
      getter url : String
    end
  end
end
