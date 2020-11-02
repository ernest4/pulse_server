# TODO: specs !?!?

module Pulse
  module Controller
    class Group < Pulse::ApplicationController
      NAMESPACE = "group"

      # TODO: secure against specific creds
      get "/#{NAMESPACE}/" do
        "groups..."
      end
    end
  end
end
