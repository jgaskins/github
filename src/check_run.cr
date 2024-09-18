require "./resource"
require "./app"
require "./pull_request"

module GitHub
  struct CheckRun
    include Resource

    getter id : Int64
    getter name : String
    getter node_id : String
    getter head_sha : String
    getter external_id : String
    getter url : URI
    getter html_url : URI
    getter details_url : URI
    getter status : Status
    getter conclusion : Conclusion = :none
    getter started_at : Time?
    getter completed_at : Time?
    getter output : Output
    getter check_suite : Suite
    # getter app : App
    getter pull_requests : Array(PullRequest)

    enum Status
      Queued
      InProgress
      Completed
    end

    enum Conclusion
      ActionRequired
      Cancelled
      Success
      Failure
      Neutral
      Skipped
      Stale
      TimedOut
      None # when the conclusion is not provided
    end

    struct Suite
      include Resource

      getter id : Int64
    end

    struct Output
      include Resource

      getter title : String?
      getter summary : String?
      getter text : String?
      getter annotations_count : Int64
      getter annotations_url : URI
    end

    struct PullRequest
      include Resource

      getter id : Int64
      getter number : Int64
      getter head : Ref
      getter base : Ref

      struct Ref
        include Resource

        getter ref : String
        getter sha : String
        getter repo : Repo
      end

      struct Repo
        include Resource

        getter id : Int64
        getter url : URI
        getter name : String
      end
    end

    struct Annotation
      include Resource

      getter path : String
      getter blob_href : URI
      getter start_line : Int32
      getter start_column : Int32?
      getter end_line : Int32
      getter end_column : Int32?
      getter annotation_level : Level
      getter title : String
      getter message : String
      getter raw_details : String

      enum Level
        Failure
        Notice
        Warning
      end
    end
  end

  struct CheckRunList
    include Resource
    include Enumerable(CheckRun)

    getter total_count : Int64
    getter check_runs : Array(CheckRun)

    def each
      check_runs.each { |cr| yield cr }
    end

    def last?
      check_runs.last?
    end
  end
end
