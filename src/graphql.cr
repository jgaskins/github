require "json"

require "./client"
require "./resource"

module GitHub
  module GraphQL
    Error.define RequestError

    struct Client
      private getter client : GitHub::Client

      def initialize(@client)
      end

      def query(
        query : String,
        variables : NamedTuple | Hash | JSON::Serializable | Nil = nil,
        *,
        as type : T.class,
      ) : Response(T) forall T
        response = client.post "/graphql",
          body: {query: query, variables: variables}.to_json

        begin
          Response(T).from_json(response.body)
        rescue ex : JSON::SerializableError
          error = begin
            ErrorResponse.from_json(response.body)
          rescue ex2 # If we couldn't parse an error, either, carry on with the original exception
            raise ex
          end
          raise RequestError.new(error.errors.map(&.message).join(", "))
        end
      end

      def query(
        *,
        operation_name : String,
        variables : NamedTuple | Hash | JSON::Serializable | Nil = nil,
        as type : T.class,
      ) : Response(T) forall T
        response = client.post "/graphql",
          body: {operationName: operation_name, variables: variables}.to_json

        begin
          Response(T).from_json(response.body)
        rescue ex : JSON::SerializableError
          begin
            error = ErrorResponse.from_json(response.body)
            raise RequestError.new(error.errors.map(&.message).join(", "))
          rescue ex2
            raise ex
          end
        end
      end
    end

    struct Response(T)
      include Resource

      getter data : T
      getter errors : Array(JSON::Any)?
    end

    struct ErrorResponse
      include Resource

      getter errors : Array(Error)
    end

    struct Error
      include Resource

      getter path : Array(String) { [] of String }
      getter extensions : Hash(String, JSON::Any) { {} of String => JSON::Any }
      getter locations : Array(Location) { [] of Location }
      getter message : String

      struct Location
        include Resource

        getter line : Int64
        getter column : Int64
      end
    end
  end
end
