require "./resource"
require "./app"
require "./pull_request"

module GitHub
  struct CheckRun
    include Resource
    include JSON::Serializable

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

    struct Output
      include Resource

      getter title : String?
      getter summary : String?
      getter text : String?
      getter annotations_count : Int64
      getter annotations_url : URI
    end

    struct Suite
      include Resource

      getter id : Int64
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
