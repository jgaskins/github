require "./resource"
require "./account"
require "./team"
require "./time_span_converter"

module GitHub
  struct Environment
    include Resource

    getter id : Int64
    getter node_id : String
    getter name : String
    getter html_url : String
    getter created_at : Time
    getter updated_at : Time
    getter protection_rules : Array(ProtectionRule)
    getter deployment_branch_policy : DeploymentBranchPolicy?

    struct DeploymentBranchPolicy
      include Resource

      getter? protected_branches : Bool
      getter? custom_branch_policies : Bool
    end

    abstract struct ProtectionRule
      include Resource

      getter id : Int64
      getter node_id : String
      getter type : String

      use_json_discriminator "type", {
        wait_timer:         WaitTimer,
        required_reviewers: RequiredReviewers,
        branch_policy:      BranchPolicy,
      }
    end

    struct RequiredReviewers < ProtectionRule
      getter reviewers : Array(Reviewer)

      struct Reviewer
        include Resource

        getter type : String
        getter reviewer : Account | Team
      end
    end

    struct WaitTimer < ProtectionRule
      @[JSON::Field(converter: GitHub::TimeSpanConverter)]
      getter wait_timer : Time::Span
    end

    struct BranchPolicy < ProtectionRule
    end
  end
end
