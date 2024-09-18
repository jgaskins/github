module GitHub
  class Error < ::Exception
    macro define(type)
      class {{type}} < ::{{@type}}
      end
    end
  end

  Error.define RequestError
  Error.define EmptyRepository
end
