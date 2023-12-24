require "json"
require "uri/json"

module GitHub
  module Resource
    macro included
      include JSON::Serializable
      include MessagePack::Serializable
      # include MessagePack::Serializable::Unmapped
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

def MessagePack::Type.new(pull : JSON::PullParser)
  from_json JSON::Any.new(pull).raw
end

def MessagePack::Type.from_json(value : Array(JSON::Any))
  value.map { |v| from_json(v).as(MessagePack::Type) }
end

def MessagePack::Type.from_json(value : Hash(String, JSON::Any))
  hash = Hash(MessagePack::Type, MessagePack::Type).new(initial_capacity: value.size)
  value.each { |k, v| hash[from_json(k)] = from_json(v) }
  hash
end

def MessagePack::Type.from_json(value : JSON::Any)
  from_json(value.raw)
end

def MessagePack::Type.from_json(value : String | Int64 | Float64 | Nil | Bool)
  value.as(MessagePack::Type)
end

struct MessagePack::Packer
  def write(value : JSON::Any)
    write value.raw
  end
end

struct JSON::Any
  def self.new(unpacker : MessagePack::Unpacker)
    new unpacker.read
  end

  def self.new(value : Array(MessagePack::Type))
    new value.map { |v| new v }
  end

  def self.new(value : Hash(MessagePack::Type, MessagePack::Type))
    hash = Hash(String, Any).new(initial_capacity: value.size)
    value.each { |k, v| hash[k.to_s] = new(v) }
    new hash
  end

  def self.new(value : Hash(String, MessagePack::Type))
    hash = Hash(String, Any).new(initial_capacity: value.size)
    value.each { |k, v| hash[k] = new(v) }
    new hash
  end

  def self.new(bytes : Bytes)
    new Base64.encode(bytes)
  end
end
