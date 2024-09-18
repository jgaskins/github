require "./resource"
require "./author_association"
require "./commit"
require "./account"

module GitHub
  struct PullRequest
    include Resource
    include JSON::Serializable::Unmapped

    getter id : Int64
    getter node_id : String
    getter number : Int64
    getter title : String
    getter body : String
    getter state : State
    getter url : URI
    getter html_url : URI
    getter diff_url : URI
    getter patch_url : URI
    getter user : Account
    getter? locked : Bool
    getter? draft : Bool
    getter closed_at : Time?
    getter merged_at : Time?
    getter merge_commit_sha : String?
    getter assignees : Array(Account)
    getter requested_reviewers : Array(Account)
    getter author_association : AuthorAssociation
    getter! comments : Int64
    getter! review_comments : Int64
    getter? maintainer_can_modify : Bool?
    getter! commits : Int64
    getter! additions : Int64
    getter! deletions : Int64
    getter! changed_files : Int64

    # Before we add these, we need a better idea of wtf they are
    getter head : Commit
    # getter base : Commit

    enum State
      # https://docs.github.com/en/graphql/reference/enums#pullrequeststate

      Open
      Closed
      Merged
    end

    struct Review
      include Resource

      getter id : Int64
      getter author_association : AuthorAssociation
      getter body : String?
      getter commit_id : String
      getter html_url : URI
      getter node_id : String
      getter pull_request_url : URI
      getter state : State
      getter submitted_at : Time
      getter user : Account
      getter _links : Links

      enum State
        Dismissed
        Approved
        ChangesRequested
        Commented
      end

      struct Links
        include Resource

        getter html : Link
        getter pull_request : Link
      end

      struct Link
        include Resource

        getter href : URI
      end

      struct Comment
        include Resource

        getter id : Int64
        getter node_id : String
        getter pull_request_review_id : Int64
        getter url : URI
        getter diff_hunk : String?
        getter path : String
        getter position : Int64?
        getter original_position : Int64?
        getter commit_id : String
        getter original_commit_id : String
        getter in_reply_to_id : Int64?
        getter user : Account
        getter body : String
        getter created_at : Time
        getter updated_at : Time
        getter html_url : URI
        getter pull_request_url : URI
        getter author_association : AuthorAssociation
      end
    end
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
