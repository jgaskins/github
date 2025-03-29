require "./branch"
require "./resource"
require "./repos"
require "./commit"
require "./diff"

module GitHub
  struct Repo
    def branch(name branch_name : String)
      BranchAPI.new client, owner, name, branch_name
    end

    def branches
      Branches.new client, owner, name
    end
  end

  struct BranchAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter name : String

    def initialize(client, @repo_owner, @repo_name, @name)
      super client
    end

    def get
      client.get "/repos/#{repo_owner}/#{repo_name}/branches/#{name}", as: Branch
    end

    def merge(into base : String, commit_message : String)
      client.post "/repos/#{repo_owner}/#{repo_name}/merges",
        body: {
          head:           name,
          base:           base,
          commit_message: commit_message,
        }.to_json
    end

    def compare(with base : String)
      client.get "/repos/#{repo_owner}/#{repo_name}/compare/#{base}...#{name}", as: Diff
    end
  end

  struct Branches < API
    getter repo_owner : String
    getter repo : String

    def initialize(client, @repo_owner, @repo)
      super client
    end

    def list
      client.get "/repos/#{@repo_owner}/#{@repo}/branches", as: Array(BranchSummary)
    end

    def get(name : String)
      client.get "/repos/#{@repo_owner}/#{@repo}/branches/#{name}", as: Branch
    end

    def merge(head : String, base : String, commit_message : String)
      client.post "/repos/#{@repo_owner}/#{@repo}/merges",
        body: {
          head:           head,
          base:           base,
          commit_message: commit_message,
        }.to_json
    end

    struct Merge
      include Resource

      property url : String

      property sha : String

      property node_id : String

      property html_url : String

      property comments_url : String

      property commit : Commit

      property author : MergeAuthor

      property committer : MergeAuthor

      property parents : Array(Tree)

      property stats : Stats

      property files : Array(FileElement)

      struct MergeAuthor
        include Resource

        property login : String

        property id : Int32

        property node_id : String

        property avatar_url : String

        property gravatar_id : String

        property url : String

        property html_url : String

        property followers_url : String

        property following_url : String

        property gists_url : String

        property starred_url : String

        property subscriptions_url : String

        property organizations_url : String

        property repos_url : String

        property events_url : String

        property received_events_url : String

        @[JSON::Field(key: "type")]
        property author_type : String

        property site_admin : Bool
      end

      struct Commit
        include Resource

        property url : String

        property author : CommitAuthor

        property committer : CommitAuthor

        property message : String

        property tree : Tree

        property comment_count : Int32

        property verification : Verification
      end

      struct CommitAuthor
        include Resource

        property name : String

        property email : String

        property date : String
      end

      struct Tree
        include Resource

        property url : String

        property sha : String
      end

      struct Verification
        include Resource

        property verified : Bool

        property reason : String

        property signature : String?

        property payload : JSON::Any
      end

      struct FileElement
        include Resource

        property filename : String

        property additions : Int32

        property deletions : Int32

        property changes : Int32

        property status : String

        property raw_url : String

        property blob_url : String

        property patch : String
      end

      struct Stats
        include Resource

        property additions : Int32

        property deletions : Int32

        property total : Int32
      end
    end
  end
end
