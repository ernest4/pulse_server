# TODO: specs !?!?

module Pulse
  module Controller
    class Home < Pulse::ApplicationController
      # NAMESPACE = "store"

      # get "/" do |env|
      #   pulse_render "home", "default"
      # end

      get "/" do |env|
        # env.redirect "/frontend/index.html"
        send_file env, "./public/frontend/index.html"
      end

      get "/app/*" do |env|
        send_file env, "./public/frontend/index.html"
      end
    end
  end
end
