require "./resource"
require "./repos"
require "./repository"
require "./api"

module GitHub
  struct Git < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def trees
      Trees.new client, repo_owner, repo_name
    end

    def commits
      Commits.new client, repo_owner, repo_name
    end

    def refs
      Refs.new client, repo_owner, repo_name
    end

    struct Trees < API
      getter repo_owner : String
      getter repo_name : String

      def initialize(client, @repo_owner, @repo_name)
        super client
      end

      def get(tree : String, recursive : Bool = false)
        if recursive
          params = "?recursive=true"
        end
        client.get "/repos/#{repo_owner}/#{repo_name}/git/trees/#{tree}#{params}", as: Tree
      end

      def create(base_tree : String, tree : Array(Blob))
        client.post "/repos/#{repo_owner}/#{repo_name}/git/trees", body: {base_tree: base_tree, tree: tree}.to_json, as: Tree
      end
    end

    struct Commits < API
      getter repo_owner : String
      getter repo_name : String

      def initialize(client, @repo_owner, @repo_name)
        super client
      end

      def create(
        message : String,
        tree : String,
        parents : Array(String)? = nil
      )
        body = CreateRequest.new(
          message: message,
          tree: tree,
          parents: parents,
        )
        client.post "/repos/#{repo_owner}/#{repo_name}/git/commits",
          body: body.to_json,
          as: Commit
      end

      struct CreateRequest
        include Resource

        getter message : String
        getter tree : String
        getter parents : Array(String)? = nil

        def initialize(*, @message, @tree, @parents)
        end
      end
    end

    struct Refs < API
      getter repo_owner : String
      getter repo_name : String

      def initialize(client, @repo_owner, @repo_name)
        super client
      end

      def get(ref_name : String)
        client.get? "/repos/#{repo_owner}/#{repo_name}/git/ref/#{ref_name}", as: Ref
      end

      def create(ref : String, sha : String)
        client.post "/repos/#{repo_owner}/#{repo_name}/git/refs", body: {ref: ref, sha: sha}.to_json, as: Ref
      end

      def update(ref : String, sha : String, force : Bool = false)
        client.patch "/repos/#{repo_owner}/#{repo_name}/git/refs/#{ref}", body: {sha: sha, force: force}.to_json, as: Ref
      end
    end

    struct Tree
      include Resource

      getter sha : String
      getter url : URI
      getter tree : Array(Blob) { [] of Blob }
      getter? truncated : Bool? = false
    end

    struct Entry
      include Resource

      getter type : Type = :blob
      getter path : String
      getter content : String?
      getter mode : String
      getter! size : Int64
      getter! sha : String
      getter! url : URI

      def initialize(@path, @content, @mode = "100644")
      end

      def to_json(json : JSON::Builder)
        json.object do
          json.field "type", type
          json.field "path", path
          json.field "mode", mode
          # Can only supply one of `sha` or `content`. Precedence goes to
          # `content`, and if neither are supplied, we send a `null` value for
          # `sha`, which deletes the file.
          if content
            json.field "content", content
          else
            json.field "sha", @sha
          end
          json.field "size", @size if @size
          json.field "url", @url if @url
        end
      end

      enum Type
        Blob
        Tree
      end
    end

    alias Blob = Entry
  end

  struct Repo
    def git
      Git.new(client, owner, name)
    end
  end
end
