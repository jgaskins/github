require "http/headers"
require "uri/params"

require "./api"
require "./issue"
require "./issue_comment"
require "./reaction"

module GitHub
  struct Issues < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def list(
      filter : Filter? = nil,
      body_type : BodyType = :text,
    ) : Array(Issue)
      params = URI::Params{
        "filter" => filter.to_s,
      }
      get "/repos/#{repo_owner}/#{repo_name}/issues?#{params}",
        headers: headers_for(body_type),
        as: Array(Issue)
    end

    private def list_with_headers(headers : ::HTTP::Headers?, params : URI::Params) : Array(Issue)
    end

    enum Filter
      Assigned
      Created
      Mentioned
      Subscribed
      Repos
      All
    end
  end

  struct IssueAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter issue_number : Int64

    def initialize(client, @repo_owner, @repo_name, @issue_number)
      super client
    end

    def get
      get_with_headers nil
    end

    def get_with_html_body : Issue
      get_with_headers headers_for :html
    end

    private def get_with_headers(headers : ::HTTP::Headers?) : Issue
      client.get "/repos/#{repo_owner}/#{repo_name}/issues/#{issue_number}",
        headers: headers,
        as: Issue
    end

    def comments
      IssueComments.new(client, repo_owner, repo_name, issue_number)
    end

    def comment(comment : IssueComment)
      comment comment.id
    end

    def comment(id : Int64)
      CommentAPI.new client, repo_owner, repo_name, issue_number, id
    end

    struct CommentAPI < API
      getter repo_owner : String
      getter repo_name : String
      getter issue_number : Int64
      getter id : Int64

      def initialize(client, @repo_owner, @repo_name, @issue_number, @id)
        super client
      end

      def reactions
        Reactions.new client, repo_owner, repo_name, issue_number, id
      end

      struct Reactions < API
        getter repo_owner : String
        getter repo_name : String
        getter issue_number : Int64
        getter comment_id : Int64

        def initialize(client, @repo_owner, @repo_name, @issue_number, @comment_id)
          super client
        end

        def create(content : Reaction::Content)
          post "/repos/#{repo_owner}/#{repo_name}/issues/comments/#{comment_id}/reactions",
            body: {content: content}.to_json,
            as: Reaction
        end

        def delete(reaction : Reaction)
          delete reaction.id
        end

        def delete(reaction_id : Int64)
          delete "/repos/#{repo_owner}/#{repo_name}/issues/comments/#{comment_id}/reactions/#{reaction_id}"
        end
      end
    end
  end

  struct IssueComments < API
    getter repo_owner : String
    getter repo_name : String
    getter issue_number : Int64

    def initialize(client, @repo_owner, @repo_name, @issue_number)
      super client
    end

    def list(per_page : String | Int | Nil = nil, body_type : BodyType = :text)
      params = URI::Params.new
      params["per_page"] = per_page.to_s if per_page
      get "/repos/#{repo_owner}/#{repo_name}/issues/#{issue_number}/comments?#{params}",
        headers: headers_for(body_type),
        as: Array(IssueComment)
    end

    def create(body : String)
      post "/repos/#{repo_owner}/#{repo_name}/issues/#{issue_number}/comments",
        body: {body: body}.to_json,
        as: IssueComment
    end
  end

  struct AssignedIssues < API
    def list
      get "/issues", as: Array(Issue)
    end
  end

  class Client
    def issues
      AssignedIssues.new self
    end
  end
end
