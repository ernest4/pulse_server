# TODO: specs !?!?

module Pulse
  module Controller
    class Store < Pulse::ApplicationController
      NAMESPACE = "store"

      # TODO: secure against specific creds
      get "/#{NAMESPACE}/" do
        "store..."
      end
    end
  end
end
