require "./resource"
require "./check_run"
require "./check_suite"
require "./repository"

module GitHub
  struct WorkflowRun
    include Resource

    {
      "id"                  => 10863448933,
      "name"                => "CI",
      "node_id"             => "WFR_kwLOMkgAf88AAAACh4MTZQ",
      "head_branch"         => "add-ci-workflow",
      "head_sha"            => "7f596d1d577804567dafac5ef1135400fb815775",
      "path"                => ".github/workflows/ci.yml",
      "display_title"       => "Add CI workflow with GitHub Actions",
      "run_number"          => 7,
      "event"               => "pull_request",
      "status"              => "completed",
      "conclusion"          => "success",
      "workflow_id"         => 117437005,
      "check_suite_id"      => 28391171724,
      "check_suite_node_id" => "CS_kwDOMkgAf88AAAAGnD7mjA",
      "url"                 => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/runs/10863448933",
      "html_url"            => "https://github.com/malakai-dev/malakai_demo/actions/runs/10863448933",
      "pull_requests"       => [
        {
          "url"    => "https://api.github.com/repos/malakai-dev/malakai_demo/pulls/46",
          "id"     => 2071914887,
          "number" => 46,
          "head"   => {
            "ref"  => "add-ci-workflow",
            "sha"  => "ba3c4ca833f819535ed7953259d5e1517e831fc9",
            "repo" => {
              "id"   => 843579519,
              "url"  => "https://api.github.com/repos/malakai-dev/malakai_demo",
              "name" => "malakai_demo",
            },
          },
          "base" => {
            "ref"  => "main",
            "sha"  => "ca318aa3075f22e7f03e7b02e0423e97eff8415a",
            "repo" => {
              "id"   => 843579519,
              "url"  => "https://api.github.com/repos/malakai-dev/malakai_demo",
              "name" => "malakai_demo",
            },
          },
        },
      ],
      "created_at" => "2024-09-14T15:13:50Z",
      "updated_at" => "2024-09-14T15:14:24Z",
      "actor"      => {
        "login"               => "jgaskins",
        "id"                  => 108205,
        "node_id"             => "MDQ6VXNlcjEwODIwNQ==",
        "avatar_url"          => "https://avatars.githubusercontent.com/u/108205?v=4",
        "gravatar_id"         => "",
        "url"                 => "https://api.github.com/users/jgaskins",
        "html_url"            => "https://github.com/jgaskins",
        "followers_url"       => "https://api.github.com/users/jgaskins/followers",
        "following_url"       => "https://api.github.com/users/jgaskins/following{/other_user}",
        "gists_url"           => "https://api.github.com/users/jgaskins/gists{/gist_id}",
        "starred_url"         => "https://api.github.com/users/jgaskins/starred{/owner}{/repo}",
        "subscriptions_url"   => "https://api.github.com/users/jgaskins/subscriptions",
        "organizations_url"   => "https://api.github.com/users/jgaskins/orgs",
        "repos_url"           => "https://api.github.com/users/jgaskins/repos",
        "events_url"          => "https://api.github.com/users/jgaskins/events{/privacy}",
        "received_events_url" => "https://api.github.com/users/jgaskins/received_events",
        "type"                => "User",
        "site_admin"          => false,
      },
      "run_attempt"          => 1,
      "referenced_workflows" => [] of String,
      "run_started_at"       => "2024-09-14T15:13:50Z",
      "triggering_actor"     => {
        "login"               => "jgaskins",
        "id"                  => 108205,
        "node_id"             => "MDQ6VXNlcjEwODIwNQ==",
        "avatar_url"          => "https://avatars.githubusercontent.com/u/108205?v=4",
        "gravatar_id"         => "",
        "url"                 => "https://api.github.com/users/jgaskins",
        "html_url"            => "https://github.com/jgaskins",
        "followers_url"       => "https://api.github.com/users/jgaskins/followers",
        "following_url"       => "https://api.github.com/users/jgaskins/following{/other_user}",
        "gists_url"           => "https://api.github.com/users/jgaskins/gists{/gist_id}",
        "starred_url"         => "https://api.github.com/users/jgaskins/starred{/owner}{/repo}",
        "subscriptions_url"   => "https://api.github.com/users/jgaskins/subscriptions",
        "organizations_url"   => "https://api.github.com/users/jgaskins/orgs",
        "repos_url"           => "https://api.github.com/users/jgaskins/repos",
        "events_url"          => "https://api.github.com/users/jgaskins/events{/privacy}",
        "received_events_url" => "https://api.github.com/users/jgaskins/received_events",
        "type"                => "User",
        "site_admin"          => false,
      },
      "jobs_url"             => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/runs/10863448933/jobs",
      "logs_url"             => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/runs/10863448933/logs",
      "check_suite_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/check-suites/28391171724",
      "artifacts_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/runs/10863448933/artifacts",
      "cancel_url"           => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/runs/10863448933/cancel",
      "rerun_url"            => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/runs/10863448933/rerun",
      "previous_attempt_url" => nil,
      "workflow_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/actions/workflows/117437005",
      "head_commit"          => {
        "id"        => "7f596d1d577804567dafac5ef1135400fb815775",
        "tree_id"   => "55068e529a0f6a83e7cad47c164cd45bd08f719e",
        "message"   => "Add GitHub Actions workflow for CI",
        "timestamp" => "2024-09-14T15:13:41Z",
        "author"    => {
          "name"  => "malakai-dev[bot]",
          "email" => "178457316+malakai-dev[bot]@users.noreply.github.com",
        },
        "committer" => {
          "name" => "Jamie Gaskins", "email" => "jgaskins@hey.com",
        },
      },
      "repository" => {
        "id"        => 843579519,
        "node_id"   => "R_kgDOMkgAfw",
        "name"      => "malakai_demo",
        "full_name" => "malakai-dev/malakai_demo",
        "private"   => true,
        "owner"     => {
          "login"               => "malakai-dev",
          "id"                  => 178456294,
          "node_id"             => "O_kgDOCqMG5g",
          "avatar_url"          => "https://avatars.githubusercontent.com/u/178456294?v=4",
          "gravatar_id"         => "",
          "url"                 => "https://api.github.com/users/malakai-dev",
          "html_url"            => "https://github.com/malakai-dev",
          "followers_url"       => "https://api.github.com/users/malakai-dev/followers",
          "following_url"       => "https://api.github.com/users/malakai-dev/following{/other_user}",
          "gists_url"           => "https://api.github.com/users/malakai-dev/gists{/gist_id}",
          "starred_url"         => "https://api.github.com/users/malakai-dev/starred{/owner}{/repo}",
          "subscriptions_url"   => "https://api.github.com/users/malakai-dev/subscriptions",
          "organizations_url"   => "https://api.github.com/users/malakai-dev/orgs",
          "repos_url"           => "https://api.github.com/users/malakai-dev/repos",
          "events_url"          => "https://api.github.com/users/malakai-dev/events{/privacy}",
          "received_events_url" => "https://api.github.com/users/malakai-dev/received_events",
          "type"                => "Organization",
          "site_admin"          => false,
        },
        "html_url"          => "https://github.com/malakai-dev/malakai_demo",
        "description"       => "Demo app for Malakai",
        "fork"              => false,
        "url"               => "https://api.github.com/repos/malakai-dev/malakai_demo",
        "forks_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/forks",
        "keys_url"          => "https://api.github.com/repos/malakai-dev/malakai_demo/keys{/key_id}",
        "collaborators_url" => "https://api.github.com/repos/malakai-dev/malakai_demo/collaborators{/collaborator}",
        "teams_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/teams",
        "hooks_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/hooks",
        "issue_events_url"  => "https://api.github.com/repos/malakai-dev/malakai_demo/issues/events{/number}",
        "events_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/events",
        "assignees_url"     => "https://api.github.com/repos/malakai-dev/malakai_demo/assignees{/user}",
        "branches_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/branches{/branch}",
        "tags_url"          => "https://api.github.com/repos/malakai-dev/malakai_demo/tags",
        "blobs_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/git/blobs{/sha}",
        "git_tags_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/git/tags{/sha}",
        "git_refs_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/git/refs{/sha}",
        "trees_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/git/trees{/sha}",
        "statuses_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/statuses/{sha}",
        "languages_url"     => "https://api.github.com/repos/malakai-dev/malakai_demo/languages",
        "stargazers_url"    => "https://api.github.com/repos/malakai-dev/malakai_demo/stargazers",
        "contributors_url"  => "https://api.github.com/repos/malakai-dev/malakai_demo/contributors",
        "subscribers_url"   => "https://api.github.com/repos/malakai-dev/malakai_demo/subscribers",
        "subscription_url"  => "https://api.github.com/repos/malakai-dev/malakai_demo/subscription",
        "commits_url"       => "https://api.github.com/repos/malakai-dev/malakai_demo/commits{/sha}",
        "git_commits_url"   => "https://api.github.com/repos/malakai-dev/malakai_demo/git/commits{/sha}",
        "comments_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/comments{/number}",
        "issue_comment_url" => "https://api.github.com/repos/malakai-dev/malakai_demo/issues/comments{/number}",
        "contents_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/contents/{+path}",
        "compare_url"       => "https://api.github.com/repos/malakai-dev/malakai_demo/compare/{base}...{head}",
        "merges_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/merges",
        "archive_url"       => "https://api.github.com/repos/malakai-dev/malakai_demo/{archive_format}{/ref}",
        "downloads_url"     => "https://api.github.com/repos/malakai-dev/malakai_demo/downloads",
        "issues_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/issues{/number}",
        "pulls_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/pulls{/number}",
        "milestones_url"    => "https://api.github.com/repos/malakai-dev/malakai_demo/milestones{/number}",
        "notifications_url" => "https://api.github.com/repos/malakai-dev/malakai_demo/notifications{?since,all,participating}",
        "labels_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/labels{/name}",
        "releases_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/releases{/id}",
        "deployments_url"   => "https://api.github.com/repos/malakai-dev/malakai_demo/deployments",
      },
      "head_repository" => {
        "id"        => 843579519,
        "node_id"   => "R_kgDOMkgAfw",
        "name"      => "malakai_demo",
        "full_name" => "malakai-dev/malakai_demo",
        "private"   => true,
        "owner"     => {
          "login"               => "malakai-dev",
          "id"                  => 178456294,
          "node_id"             => "O_kgDOCqMG5g",
          "avatar_url"          => "https://avatars.githubusercontent.com/u/178456294?v=4",
          "gravatar_id"         => "",
          "url"                 => "https://api.github.com/users/malakai-dev",
          "html_url"            => "https://github.com/malakai-dev",
          "followers_url"       => "https://api.github.com/users/malakai-dev/followers",
          "following_url"       => "https://api.github.com/users/malakai-dev/following{/other_user}",
          "gists_url"           => "https://api.github.com/users/malakai-dev/gists{/gist_id}",
          "starred_url"         => "https://api.github.com/users/malakai-dev/starred{/owner}{/repo}",
          "subscriptions_url"   => "https://api.github.com/users/malakai-dev/subscriptions",
          "organizations_url"   => "https://api.github.com/users/malakai-dev/orgs",
          "repos_url"           => "https://api.github.com/users/malakai-dev/repos",
          "events_url"          => "https://api.github.com/users/malakai-dev/events{/privacy}",
          "received_events_url" => "https://api.github.com/users/malakai-dev/received_events",
          "type"                => "Organization",
          "site_admin"          => false,
        },
        "html_url"          => "https://github.com/malakai-dev/malakai_demo",
        "description"       => "Demo app for Malakai",
        "fork"              => false,
        "url"               => "https://api.github.com/repos/malakai-dev/malakai_demo",
        "forks_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/forks",
        "keys_url"          => "https://api.github.com/repos/malakai-dev/malakai_demo/keys{/key_id}",
        "collaborators_url" => "https://api.github.com/repos/malakai-dev/malakai_demo/collaborators{/collaborator}",
        "teams_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/teams",
        "hooks_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/hooks",
        "issue_events_url"  => "https://api.github.com/repos/malakai-dev/malakai_demo/issues/events{/number}",
        "events_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/events",
        "assignees_url"     => "https://api.github.com/repos/malakai-dev/malakai_demo/assignees{/user}",
        "branches_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/branches{/branch}",
        "tags_url"          => "https://api.github.com/repos/malakai-dev/malakai_demo/tags",
        "blobs_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/git/blobs{/sha}",
        "git_tags_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/git/tags{/sha}",
        "git_refs_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/git/refs{/sha}",
        "trees_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/git/trees{/sha}",
        "statuses_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/statuses/{sha}",
        "languages_url"     => "https://api.github.com/repos/malakai-dev/malakai_demo/languages",
        "stargazers_url"    => "https://api.github.com/repos/malakai-dev/malakai_demo/stargazers",
        "contributors_url"  => "https://api.github.com/repos/malakai-dev/malakai_demo/contributors",
        "subscribers_url"   => "https://api.github.com/repos/malakai-dev/malakai_demo/subscribers",
        "subscription_url"  => "https://api.github.com/repos/malakai-dev/malakai_demo/subscription",
        "commits_url"       => "https://api.github.com/repos/malakai-dev/malakai_demo/commits{/sha}",
        "git_commits_url"   => "https://api.github.com/repos/malakai-dev/malakai_demo/git/commits{/sha}",
        "comments_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/comments{/number}",
        "issue_comment_url" => "https://api.github.com/repos/malakai-dev/malakai_demo/issues/comments{/number}",
        "contents_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/contents/{+path}",
        "compare_url"       => "https://api.github.com/repos/malakai-dev/malakai_demo/compare/{base}...{head}",
        "merges_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/merges",
        "archive_url"       => "https://api.github.com/repos/malakai-dev/malakai_demo/{archive_format}{/ref}",
        "downloads_url"     => "https://api.github.com/repos/malakai-dev/malakai_demo/downloads",
        "issues_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/issues{/number}",
        "pulls_url"         => "https://api.github.com/repos/malakai-dev/malakai_demo/pulls{/number}",
        "milestones_url"    => "https://api.github.com/repos/malakai-dev/malakai_demo/milestones{/number}",
        "notifications_url" => "https://api.github.com/repos/malakai-dev/malakai_demo/notifications{?since,all,participating}",
        "labels_url"        => "https://api.github.com/repos/malakai-dev/malakai_demo/labels{/name}",
        "releases_url"      => "https://api.github.com/repos/malakai-dev/malakai_demo/releases{/id}",
        "deployments_url"   => "https://api.github.com/repos/malakai-dev/malakai_demo/deployments",
      },
    }

    getter id : Int64
    getter name : String
    getter node_id
    getter head_branch : String
    getter head_sha : String
    getter path : String
    getter display_title : String
    getter run_number : Int64
    getter event : String
    getter status : CheckSuite::Status
    getter conclusion : CheckSuite::Conclusion
    getter workflow_id : Int64
    getter check_suite_id : Int64
    getter check_suite_node_id : String
    getter url : URI
    getter html_url : URI
    getter pull_requests : Array(CheckRun::PullRequest)
    getter created_at : Time
    getter updated_at : Time
    getter actor : Account
    getter run_attempt : Int64
    getter referenced_workflows : Array(JSON::Any)
    getter run_started_at : Time
    getter triggering_actor : Account
    getter previous_attempt_url : URI?
    getter logs_url : URI
    getter head_commit : JSON::Any
    getter repository : Repository
    getter head_repository : Repository

    struct Repository
      include Resource

      getter id : Int64
      getter node_id : String
      getter name : String
      getter full_name : String
      getter? private : Bool
      getter owner : Account
      getter html_url : URI
      getter description : String?
      getter? fork : Bool
      getter url : URI
    end
  end
end
