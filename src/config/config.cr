module Pulse
  module Config
    extend self

    ENVIRONMENT = ENV["KEMAL_ENV"]? || "development"
    ENVIRONMENTS = ["production", "test", "development"]

    {% for environment in ENVIRONMENTS %}
      def {{environment.id}}?
        ENVIRONMENT == {{environment}}
      end
    {% end %}
  end
end

# auto load the initializers
require "./initializers/*" 