require "json"
require "uri/json"

module GitHub
  module Resource
    macro included
      include JSON::Serializable
      # include JSON::Serializable::Unmapped
    end

    macro field(var)
      @[JSON::Field(key: {{var.var.camelcase(lower: true)}})]
      getter {{var}}
    end
  end
end

class URI
  def inspect(io) : Nil
    io << "URI("
    to_s io
    io << ')'
  end
end
