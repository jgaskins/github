require "./resource"
require "./account"

module GitHub
  struct Repository
    include Resource

    getter id : Int64
    getter node_id : String
    getter name : String
    getter full_name : String
    getter description : String { "" }
    getter owner : Account
    getter? private : Bool
    getter visibility : Visibility
    getter? fork : Bool
    getter url : URI
    getter created_at : Time
    getter updated_at : Time
    getter pushed_at : Time?
    getter git_url : URI
    getter ssh_url : String
    getter clone_url : URI
    getter svn_url : URI
    getter homepage : URI?
    getter size : Int64
    getter stargazers_count : Int64
    getter watchers_count : Int64
    getter language : String?
    getter? has_issues : Bool
    getter? has_projects : Bool
    getter? has_downloads : Bool
    getter? has_wiki : Bool
    getter? has_pages : Bool
    getter? has_discussions : Bool
    getter forks_count : Int64
    getter mirror_url : URI?
    getter? archived : Bool
    getter? disabled : Bool
    getter open_issues_count : Int64
    getter license : JSON::Any?
    getter? allow_forking : Bool
    getter? is_template : Bool
    getter? web_commit_signoff_required : Bool
    getter topics : Array(String)
    getter open_issues : Int64
    getter default_branch : String
    getter custom_properties : Hash(String, String) { {} of String => String }

    enum Visibility
      Public
      Private
    end
  end
end
