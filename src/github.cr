require "./client"
require "./version"

# TODO: Write documentation for `GitHub`
module GitHub
  macro define_type(name, *vars, &block)
    struct {{name}}
      include ::GitHub::Resource

      {% for var in vars %}
        field {{var}}
      {% end %}

      {{yield}}
    end
  end
end
