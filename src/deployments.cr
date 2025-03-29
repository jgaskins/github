require "./repos"
require "./deployment"

module GitHub
  struct Repo
    def deployments
      Deployments.new(client, owner, name)
    end

    def deployment(deployment : Deployment)
      deployment deployment.id
    end

    def deployment(deployment_id : Int64)
      DeploymentAPI.new client, owner, name, deployment_id
    end
  end

  struct DeploymentAPI < API
    getter repo_owner : String
    getter repo_name : String
    getter deployment_id : Int64

    def initialize(client, @repo_owner, @repo_name, @deployment_id)
      super client
    end

    def statuses
      Statuses.new client, repo_owner, repo_name, deployment_id
    end

    struct Statuses < API
      getter repo_owner : String
      getter repo_name : String
      getter deployment_id : Int64

      def initialize(client, @repo_owner, @repo_name, @deployment_id)
        super client
      end

      def create(
        state : Deployment::Status::State,
        *,
        log_url : String? = nil,
        description : String? = nil,
        environment : String? = nil,
        environment_url : String? = nil,
        auto_inactive : Bool? = nil,
      ) : Deployment::Status
        request = CreateRequest.new state,
          log_url: log_url,
          description: description,
          environment: environment,
          environment_url: environment_url,
          auto_inactive: auto_inactive

        client.post "/repos/#{repo_owner}/#{repo_name}/deployments/#{deployment_id}/statuses",
          body: request.to_json,
          as: Deployment::Status
      end

      struct CreateRequest
        include Resource
        getter state : Deployment::Status::State
        getter log_url : String? = nil
        getter description : String? = nil
        getter environment : String? = nil
        getter environment_url : String? = nil
        getter auto_inactive : Bool? = nil

        def initialize(@state, *, @log_url, @description, @environment, @environment_url, @auto_inactive)
        end
      end
    end
  end

  struct Deployments < API
    getter repo_owner : String
    getter repo_name : String

    def initialize(client, @repo_owner, @repo_name)
      super client
    end

    def list
      client.get "/repos/#{repo_owner}/#{repo_name}/deployments", as: Array(Deployment)
    end

    def create(
      ref : String,
      task : String? = nil,
      auto_merge : Bool? = nil,
      required_contexts : Array(String)? = nil,
      payload = nil,
      environment : String? = nil,
      description : String? = nil,
      transient_environment : Bool? = nil,
      production_environment : Bool? = nil,
    ) : Deployment
      request = CreateDeploymentRequest.new ref,
        task: task,
        auto_merge: auto_merge,
        required_contexts: required_contexts,
        payload: payload,
        environment: environment,
        description: description,
        transient_environment: transient_environment,
        production_environment: production_environment

      client.post "/repos/#{repo_owner}/#{repo_name}/deployments",
        body: request.to_json,
        as: Deployment
    end

    def delete(deployment : Deployment)
      delete deployment.id
    end

    def delete(id : Int64)
      client.delete "/repos/#{repo_owner}/#{repo_name}/deployments/#{id}"
    end

    struct CreateDeploymentRequest(Payload)
      include Resource

      getter ref : String
      getter task : String?
      getter auto_merge : Bool?
      getter required_contexts : Array(String)?
      getter payload : Payload
      getter environment : String?
      getter description : String?
      getter transient_environment : Bool?
      getter production_environment : Bool?

      def initialize(
        @ref,
        *,
        @task = nil,
        @auto_merge = nil,
        @required_contexts = nil,
        @payload = nil,
        @environment = nil,
        @description = nil,
        @transient_environment = nil,
        @production_environment = nil,
      )
      end
    end
  end
end
