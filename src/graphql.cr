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
        as type : T.class
      ) : Response(T) forall T
        response = client.post "/graphql",
          body: {
            query:     query,
            variables: variables,
          }.to_json,
          as: Response(T) | ErrorResponse

        case response
        in Response
          response
        in ErrorResponse
          raise RequestError.new(response.errors.map(&.message).join(", "))
        end
      end

      def query(
        *,
        operation_name : String,
        variables : NamedTuple | Hash | JSON::Serializable | Nil = nil,
        as type : T.class
      ) : Response(T) forall T
        response = client.post "/graphql",
          body: {
            operationName: operation_name,
            variables:     variables,
          }.to_json,
          as: Response(T) | ErrorResponse

        case response
        in Response
          response
        in ErrorResponse
          raise RequestError.new(response.errors.map(&.message).join(", "))
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
