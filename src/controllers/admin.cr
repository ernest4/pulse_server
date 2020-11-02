# TODO: specs !?!?

module Pulse
  module Controller
    class Admin < Pulse::ApplicationController
      NAMESPACE = "admin"

      # TODO: secure against specific creds
      get "/#{NAMESPACE}/" do
        "server admin only..."
      end
    end
  end
end
