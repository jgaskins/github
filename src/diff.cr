require "./resource"

module GitHub
  struct Diff
    include Resource
    include JSON::Serializable::Unmapped

    getter html_url : String
    getter diff_url : String
    getter patch_url : String
    getter base_commit : CommitDetail
    getter merge_base_commit : CommitDetail
    getter status : Status
    getter ahead_by : Int64
    getter behind_by : Int64
    getter total_commits : Int64
    getter commits : Array(CommitDetail)
    getter files : Array(FilePatch)

    enum Status
      Diverged
      Ahead
      Behind
      Identical
    end

    struct FilePatch
      include Resource
      include JSON::Serializable::Unmapped

      getter sha : String
      getter filename : String
      getter status : Status
      getter additions : Int64
      getter deletions : Int64
      getter changes : Int64
      getter blob_url : String
      getter raw_url : String
      getter patch : String

      enum Status
        Added
        Removed
        Modified
        Renamed
        Copied
        Changed
        Unchanged
      end
    end
  end
end
