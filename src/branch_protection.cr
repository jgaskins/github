module GitHub
  struct BranchProtection
    include Resource

    getter? enabled : Bool
    getter required_status_checks : RequiredStatusChecks
  end

  struct RequiredStatusChecks
    include Resource

    getter enforcement_level : EnforcementLevel
    getter contexts : Array(JSON::Any)
    getter checks : Array(JSON::Any)

    enum EnforcementLevel
      On
      Off
      NonAdmins
    end
  end
end
