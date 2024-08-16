require "./resource"
require "./account"

module GitHub
  struct Installation
    include Resource
    include JSON::Serializable::Unmapped

    getter id : Int64
    getter account : Account
    getter repository_selection : String
    getter access_tokens_url : String
    getter repositories_url : String
    getter html_url : String
    getter app_id : Int64
    getter app_slug : String
    getter target_id : Int64
    getter target_type : String
    getter permissions : Permissions
    getter events : Array(String)
    getter created_at : Time
    getter updated_at : Time
    getter single_file_name : String?
    getter? has_multiple_single_files : Bool?
    getter single_file_paths : Array(String) { [] of String }
    getter suspended_by : Account?
    getter suspended_at : Time?

    struct Permissions
      include JSON::Serializable

      macro define_permission(name)
      @[JSON::Field(ignore_deserialize: {{name}}.none?)]
      getter {{name}} : Permission = :none
    end

      macro define_permissions(*permissions)
      {% for permission in permissions %}
        define_permission {{permission.id}}
      {% end %}
    end

      # See `permissions` properties at https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#create-an-installation-access-token-for-an-app
      define_permissions(
        actions,
        administration,
        checks,
        codespaces,
        contents,
        dependabot_secrets,
        deployments,
        environments,
        issues,
        metadata,
        packages,
        pages,
        pull_requests,
        repository_custom_properties,
        repository_hooks,
        repository_projects,
        secret_scanning_alerts,
        secrets,
        security_events,
        single_file,
        statuses,
        vulnerability_alerts,
        workflows,
        members,
        organization_administration,
        organization_custom_roles,
        organization_custom_org_roles,
        organization_custom_properties,
        organization_copilot_seat_management,
        organization_announcement_banners,
        organization_events,
        organization_hooks,
        organization_personal_access_tokens,
        organization_personal_access_token_requests,
        organization_plan,
        organization_projects,
        organization_packages,
        organization_secrets,
        organization_self_hosted_runners,
        organization_user_blocking,
        team_discussions,
        email_addresses,
        followers,
        git_ssh_keys,
        gpg_keys,
        interaction_limits,
        profile,
        starring,
      )

      enum Permission
        None
        Read
        Write
      end
    end

    struct List
      include Resource
      include Enumerable(Installation)

      getter total_count : Int64
      getter installations : Array(Installation)

      def each
        installations.each { |i| yield i }
      end
    end
  end

  struct InstallationToken
    include Resource

    getter token : String
    getter expires_at : Time
    getter permissions : Hash(String, Permission)
    getter repository_selection : JSON::Any

    def expired?(now : Time = Time.utc)
      expires_at < now
    end

    enum Permission
      None
      Read
      Write
    end
  end
end
