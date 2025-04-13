require "./api"
require "compress/zip"

# TODO: invert these dependencies so working with a repo doesn't load everything
# you could possibly do with a repo.
require "./issues"
require "./pulls"
require "./commits"
require "./repository"
require "./base64_converter"

module GitHub
  struct Repo < API
    getter owner : String
    getter name : String

    def initialize(client, @owner, @name)
      super client
    end

    def issue(issue : Issue)
      issue issue.number
    end

    def issue(number : Int)
      IssueAPI.new(client, owner, name, number)
    end

    def issues
      Issues.new(client, owner, name)
    end

    def pull(number : Int64 | Int32)
      Pull.new(client, owner, name, number.to_i64)
    end

    def pulls
      Pulls.new(client, owner, name)
    end

    def commit(commit : CommitDetail)
      commit commit.sha # lol
    end

    def commit(ref : String)
      CommitAPI.new(client, owner, name, ref)
    end

    def contents
      Contents.new(client, owner, name)
    end

    def zipball(ref : String, &block : Compress::Zip::File ->)
      client.http_get "/repos/#{owner}/#{name}/zipball/#{ref}" do |response|
        if response.success?
          file = File.tempfile do |tempfile|
            IO.copy response.body_io, tempfile
          end
          begin
            Compress::Zip::File.open(file.path) { |zip| block.call zip }
          ensure
            file.delete
          end
        elsif response.status.not_found? && get # if the repo exists, it's empty
          raise EmptyRepository.new("Cannot retrieve a zipball for an empty repository")
        else
          raise RequestError.new("#{response.status} - #{response.body_io.gets_to_end}")
        end
      end
    end

    def get
      client.get "/repos/#{owner}/#{name}", as: Repository
    end

    struct Contents < API
      getter repo_owner : String
      getter repo_name : String

      def initialize(client, @repo_owner, @repo_name)
        super client
      end

      def get(path : String, *, ref : String?) : FileContent
        if ref
          params = URI::Params{"ref" => ref}
        end

        client.get "/repos/#{repo_owner}/#{repo_name}/contents/#{path}?#{params}",
          as: FileContent
      end

      struct FileContent
        include Resource

        getter name : String
        getter path : String
        getter sha : String
        getter size : Int64
        getter url : String
        getter html_url : String
        getter git_url : String
        getter download_url : String
        getter type : String                                 # enum?
        @[JSON::Field(converter: ::GitHub::Base64Converter)] # is this universal?
        getter content : String
        getter encoding : String # enum?
      end
    end
  end

  struct Repos < API
    def initialize(client)
      super client
    end

    def accessible_to_me(
      page : Int64? = nil,
      per_page : Int32? = nil,
      visibility : Visibility? = nil,
      type : Type? = nil,
      sort : Sort? = nil,
      direction : Direction? = nil,
      since : Time? = nil,
      before : Time? = nil
    ) : List(Repository)
      accessible_to_me(
        page: page,
        per_page: per_page,
        visibility: visibility,
        type: type,
        sort: sort,
        direction: direction,
        since: since,
        before: before,
        fetch_next_page: page.nil?,
      )
    end

    protected def accessible_to_me(
      *,
      page : Int64? = nil,
      per_page : Int32? = nil,
      visibility : Visibility? = nil,
      type : Type? = nil,
      sort : Sort? = nil,
      direction : Direction? = nil,
      since : Time? = nil,
      before : Time? = nil,
      fetch_next_page
    ) : List(Repository)
      params = URI::Params.new
      params["page"] = page.to_s if page
      params["per_page"] = per_page.to_s if per_page
      params["visibility"] = visibility.to_s if visibility
      params["type"] = type.to_s if type
      params["sort"] = sort.to_s if sort
      params["direction"] = direction.to_s if direction
      params["since"] = since.to_rfc3339 if since
      params["before"] = before.to_rfc3339 if before

      list = client.get "/user/repos?#{params}", as: List(Repository)
      if per_page
        list.expected_size = per_page
      end
      if fetch_next_page
        list.fetch_next_page do
          accessible_to_me(
            page: (page || 1i64) + 1,
            per_page: per_page,
            visibility: visibility,
            type: type,
            sort: sort,
            direction: direction,
            since: since,
            before: before,
            fetch_next_page: true,
          )
        end
      end
      list
    end

    struct List(T)
      include Enumerable(T)

      getter items : Array(T)
      @[JSON::Field(ignore: true)]
      protected property expected_size : Int32 = 30 # the default size from the API
      @[JSON::Field(ignore: true)]
      @fetch_next_page : Proc(self)?

      def initialize(json : JSON::PullParser)
        @items = Array(T).new(json)
      end

      def each(&block : T ->) : Nil
        items.each { |item| yield item }

        # We don't attempt to fetch the next page if this one's not filled
        if (fetch_next_page = @fetch_next_page) && items.size >= expected_size
          fetch_next_page.call.each(&block)
        end
      end

      def to_a
        array = Array(T).new(initial_capacity: items.size)
        each { |item| array << item }
        array
      end

      protected def fetch_next_page(&@fetch_next_page : -> self)
        self
      end
    end

    enum Visibility
      All
      Public
      Private

      private def member_name
        # Can't use `case` here because case with duplicate values do
        # not compile, but enums can have duplicates (such as `enum Foo; FOO = 1; BAR = 1; end`).
        {% for member in @type.constants %}
          if value == {{@type.constant(member)}}
            return {{member.underscore.stringify}}
          end
        {% end %}
      end
    end

    enum Type
      All
      Owner
      Public
      Private
      Member

      private def member_name
        # Can't use `case` here because case with duplicate values do
        # not compile, but enums can have duplicates (such as `enum Foo; FOO = 1; BAR = 1; end`).
        {% for member in @type.constants %}
          if value == {{@type.constant(member)}}
            return {{member.underscore.stringify}}
          end
        {% end %}
      end
    end

    enum Sort
      Created
      Updated
      Pushed
      FullName

      private def member_name
        # Can't use `case` here because case with duplicate values do
        # not compile, but enums can have duplicates (such as `enum Foo; FOO = 1; BAR = 1; end`).
        {% for member in @type.constants %}
          if value == {{@type.constant(member)}}
            return {{member.underscore.stringify}}
          end
        {% end %}
      end
    end

    enum Direction
      ASC
      DESC

      private def member_name
        # Can't use `case` here because case with duplicate values do
        # not compile, but enums can have duplicates (such as `enum Foo; FOO = 1; BAR = 1; end`).
        {% for member in @type.constants %}
          if value == {{@type.constant(member)}}
            return {{member.underscore.stringify}}
          end
        {% end %}
      end
    end
  end

  class Client
    def repo(repository : Repository)
      repo repository.owner.login, repository.name
    end

    def repo(owner : String, name : String)
      Repo.new(self, owner, name)
    end

    def repos
      Repos.new(self)
    end
  end
end
