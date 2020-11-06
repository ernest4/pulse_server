# TODO: specs !?!?

module Pulse
  module Controller
    class Play < Pulse::ApplicationController
      # NAMESPACE = "store"

      # get "/play" do |env|
      #   pulse_render "testy_html"
      # end

      # get "/" do |env|
      #   # env.redirect "/frontend/index.html"
      #   send_file env, "./public/frontend/index.html"
      # end

      # TODO: check if user is authorized, if not redirect to log in page (home page)?
      get "/play" do |env|
        send_file env, "./public/game/index.html"
      end
    end
  end
end
