# TODO: specs !?!?

module Pulse
  module Controller
    class Home < Pulse::ApplicationController
      # NAMESPACE = "store"

      get "/" do |env|
        pulse_render "home", "default"
      end
    end
  end
end
