# TODO: specs !?!?

module Pulse
  module Controller
    class Account < Pulse::ApplicationController
      # TODO: SPECS !!!
      get "/account" do |env|
        authenticate_and_redirect
      
        user = ::User.where { _uid == env.session.string("uid") }.first
      
        pulse_render "account", "default"
      end
    end
  end
end
