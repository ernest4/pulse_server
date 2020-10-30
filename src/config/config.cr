module Pulse
  module Config
    ENVIRONMENT = ENV["KEMAL_ENV"]? || "development"
  end
end

# auto load the initializers
require "./initializers/*" 