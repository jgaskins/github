require "./resource"
require "./check_run"

module GitHub
  struct CheckSuite
    include Resource

    getter id : Int64
    getter node_id : String
    getter head_branch : String
    getter head_sha : String
    getter status : Status
    getter conclusion : Conclusion = :none
    getter url : URI
    getter before : String
    getter after : String
    getter pull_requests : Array(CheckRun::PullRequest)
    getter created_at : Time
    getter updated_at : Time

    enum Status
      Queued
      InProgress
      Completed
      Pending
      Waiting
    end

    enum Conclusion
      Success
      Failure
      Neutral
      Cancelled
      TimedOut
      ActionRequired
      Stale
      None
      Skipped
      StartupFailure
    end
  end
end
