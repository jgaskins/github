require "./resource"

module GitHub
  struct Issue
    include Resource
    include JSON::Serializable::Unmapped

    getter id : Int64
    getter node_id : String
    getter url : URI
    getter html_url : URI
    getter number : Int64
    getter title : String
    getter user : Account
    getter labels : JSON::Any
    getter state : State
    getter? locked : Bool = false
    getter assignee : Account?
    getter assignees : Array(Account) { [] of Account }
    getter milestone : JSON::Any
    getter comments : Int64
    getter created_at : Time
    getter updated_at : Time
    getter closed_at : Time?
    getter author_association : AuthorAssociation?
    getter active_lock_reason : String?
    getter body : String { body_html }
    getter body_html : String { body }
    getter reactions : Reactions
    getter performed_via_github_app : JSON::Any
    getter state_reason : String?

    struct Reactions
      include Resource

      getter url : URI
      getter total_count : Int64
      @[JSON::Field(key: "+1")]
      getter thumbs_up : Int64
      @[JSON::Field(key: "-1")]
      getter thumbs_down : Int64
      getter laugh : Int64
      getter hooray : Int64
      getter confused : Int64
      getter heart : Int64
      getter rocket : Int64
      getter eyes : Int64
    end

    enum State
      Open
      Closed
    end

    @[Flags]
    enum AuthorAssociation
      Owner
      Collaborator
      OrganizationMember

      def self.new(json : JSON::PullParser) : self
        string = json.read_string
        value = None
        string.split(',').each do |string|
          {Owner, Collaborator, OrganizationMember}.each do |member|
            if string.compare(member.to_s, case_insensitive: true) == 0
              value |= member
            end
          end
        end
        value
      end
    end
  end
end
