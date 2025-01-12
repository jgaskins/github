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

    def list
      client.get "/repos/#{@repo_owner}/#{@repo_name}/pulls", as: Array(PullRequest)
    end

    def create(title : String, body : String, head : String, base : String) : PullRequest
      client.post "/repos/#{@repo_owner}/#{@repo_name}/pulls",
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
      client.get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}",
        as: PullRequest
    end

    def get_with_html_body
      client.get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}",
        headers: headers_for(:html),
        as: PullRequest
    end

    def diff : String
      headers = HTTP::Headers{"accept" => "application/vnd.github.v3.diff"}
      client.http_get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}", headers: headers do |response|
        if response.success?
          response.body_io.gets_to_end
        else
          raise RequestError.new("#{response.status.code} #{response.status} #{response.body_io.gets_to_end}")
        end
      end
    end

    def commits
      client.get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}/commits",
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
          client.post "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{number}/comments/#{comment_id}/replies",
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
        client.post "/repos/#{@repo_owner}/#{@repo_name}/issues/#{@number}/comments",
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

      def get(body_type : BodyType = :text)
        client.get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}/reviews/#{review_id}",
          headers: headers_for(body_type),
          as: PullRequest::Review
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
          body_type : BodyType = :text,
        )
          params = URI::Params.new
          params["per_page"] = per_page.to_s if per_page
          params["page"] = page.to_s if page

          client.get "/repos/#{@repo_owner}/#{@repo_name}/pulls/#{@number}/reviews/#{review_id}/comments?#{params}",
            headers: headers_for(body_type),
            as: Array(PullRequest::Review::Comment)
        end
      end
    end
  end
end
