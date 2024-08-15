require "./resource"

module GitHub
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
