# TODO: specs !?!?

module Pulse
  module Controller
    class Home < Pulse::ApplicationController
      # NAMESPACE = "store"

      get "/" do |env|
        if env.session.string?("uid")
          characters = ::User.where { _uid == env.session.string("uid") }.first!.characters
        end

        puts characters

        pulse_render "home", "default"
      end

      # get "/" do |env|
      #   # env.redirect "/frontend/index.html"
      #   send_file env, "./public/frontend/index.html"
      # end

      # get "/app/*" do |env|
      #   send_file env, "./public/frontend/index.html"
      # end
    end
  end
end
