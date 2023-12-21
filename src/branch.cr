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

  struct BranchDetail
    include Resource

    getter name : String
    getter commit : CommitDetail
    getter? protected : Bool
    getter protection : BranchProtection?
    getter protection_url : URI?
  end
end
