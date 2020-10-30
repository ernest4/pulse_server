module Pulse
  module Config
    ENVIRONMENT = ENV["KEMAL_ENV"]? || "development"
  end
end

# load the initializers automatically
require "./initializers/*" 