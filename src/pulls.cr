require "./api"
require "./commit"
require "./pull_request"

module GitHub
  struct Pulls < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def create(title : String, body : String, head : String, base : String) : PullRequest
      post "/repos/#{@repo_owner}/#{@repo_name}/pulls",
        body: {title: title, body: body, head: head, base: base}.to_json,
        as: PullRequest
    end
  end

  struct Pull < API
    getter repo_owner : String
    getter repo_name : String
    getter number : Int64

    def initialize(client, @repo_owner, @repo_name, @number)
      super client
    end

    def get
      get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}",
        as: PullRequest
    end

    def commits
      get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}/commits",
        as: Array(CommitDetail)
    end

    def comment(id : Int64)
      Comment.new(client, repo_owner, repo_name, number, id)
    end

    def comments
      Comments.new(client, repo_owner, repo_name, number)
    end

    def review(review_id : Int64)
      Review.new client, repo_owner, repo_name, number, review_id
    end

    struct Comment < API
      getter repo_owner : String
      getter repo_name : String
      getter number : Int64
      getter comment_id : Int64

      def initialize(client, @repo_owner, @repo_name, @number, @comment_id)
        super client
      end

      def replies
        Replies.new client, repo_owner, repo_name, number, comment_id
      end

      struct Replies < API
        getter repo_owner : String
        getter repo_name : String
        getter number : Int64
        getter comment_id : Int64

        def initialize(client, @repo_owner, @repo_name, @number, @comment_id)
          super client
        end

        def create(body : String)
          post "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{number}/comments/#{comment_id}/replies",
            body: {body: body}.to_json,
            as: PullRequest::Review::Comment
        end
      end
    end

    struct Comments < API
      getter repo_owner : String
      getter repo_name : String
      getter number : Int64

      def initialize(client, @repo_owner, @repo_name, @number)
        super client
      end

      def create(body : String)
        post "/repos/#{@repo_owner}/#{@repo_name}/issues/#{@number}/comments",
          {body: body}.to_json,
          as: JSON::Any
      end
    end

    struct Review < API
      getter repo_owner : String
      getter repo_name : String
      getter number : Int64
      getter review_id : Int64

      def initialize(client, @repo_owner, @repo_name, @number, @review_id)
        super client
      end

      def comments
        Comments.new client, repo_owner, repo_name, number, review_id
      end

      struct Comments < API
        getter repo_owner : String
        getter repo_name : String
        getter number : Int64
        getter review_id : Int64

        def initialize(client, @repo_owner, @repo_name, @number, @review_id)
          super client
        end

        def list(
          page : String | Int | Nil = nil,
          per_page : String | Int | Nil = nil,
        )
          params = URI::Params.new
          params["per_page"] = per_page.to_s if per_page
          params["page"] = page.to_s if page

          get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}/reviews/#{review_id}/comments?#{params}",
            as: Array(PullRequest::Review::Comment)
        end
      end
    end
  end
end
