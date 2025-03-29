require "./resource"
require "./account"

module GitHub
  module RefProperties
    getter sha : String
    getter url : URI
  end

  struct Ref
    include Resource

    getter ref : String
    getter node_id : String
    getter url : URI
    getter object : Object

    struct Object
      include Resource
      getter type : String
      getter sha : String
      getter url : URI
    end
  end

  struct CommitEntry
    include Resource
    include RefProperties

    getter html_url : URI?
  end

  struct CommitDetail
    include Resource
    include RefProperties

    getter commit : Commit
    getter node_id : String
    getter html_url : URI
    getter comments_url : URI
    getter author : Account
    getter committer : Account
    getter parents : Array(CommitEntry)
  end

  struct Commit
    include Resource
    include JSON::Serializable::Unmapped

    getter! sha : String
    getter! message : String
    getter! ref : String
    # getter node_id : String
    # getter url : URI
    getter! author : Actor
    getter! committer : Actor
    getter! tree : CommitEntry
    getter! parents : Array(CommitEntry)
    getter! verification : Verification
    getter! comment_count : Int64
    # getter html_url : URI
  end

  struct Actor
    include Resource

    getter name : String
    getter email : String
    getter date : Time
  end

  struct Verification
    include Resource

    getter? verified : Bool
    getter reason : Reason
    getter signature : String?
    getter payload : String?
    getter verified_at : Time?

    enum Reason
      # Value	Description
      # The key that made the signature is expired.
      EXPIRED_KEY
      # The "signing" flag is not among the usage flags in the GPG key that made the signature.
      NOT_SIGNING_KEY
      # There was an error communicating with the signature verification service.
      GPGVERIFY_ERROR
      # The signature verification service is currently unavailable.
      GPGVERIFY_UNAVAILABLE
      # The object does not include a signature.
      UNSIGNED
      # A non-PGP signature was found in the commit.
      UNKNOWN_SIGNATURE_TYPE
      # No user was associated with the committer email address in the commit.
      NO_USER
      # The committer email address in the commit was associated with a user, but the email address is not verified on their account.
      UNVERIFIED_EMAIL
      # The committer email address in the commit is not included in the identities of the PGP key that made the signature.
      BAD_EMAIL
      # The key that made the signature has not been registered with any user's account.
      UNKNOWN_KEY
      # There was an error parsing the signature.
      MALFORMED_SIGNATURE
      # The signature could not be cryptographically verified using the key whose key-id was found in the signature.
      INVALID
      # None of the above errors applied, so the signature is considered to be verified.
      VALID
    end
  end
end
