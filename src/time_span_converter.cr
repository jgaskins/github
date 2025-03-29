module GitHub
  module TimeSpanConverter
    extend self

    def from_json(json : JSON::PullParser) : ::Time::Span
      json.read_int.minutes
    end

    def to_json(value : ::Time::Span, json : ::JSON::Builder) : Nil
      json.number value.total_minutes.to_i64
    end
  end
end
