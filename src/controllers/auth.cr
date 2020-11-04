# TODO: specs !?!?

# TODO: SPECS !!! # TODO: SPECS !!! # TODO: SPECS !!!
module Pulse
  module Controller
    class Auth < Pulse::ApplicationController
      NAMESPACE = "multi-auth"

      # TODO: SPECS !!!
      get "/#{NAMESPACE}/:provider" do |env|
        env.redirect(multi_auth(env).authorize_uri("openid email profile"))
      end

      # TODO: SPECS !!!
      get "/#{NAMESPACE}/:provider/callback" do |env|
        social_auth_user = multi_auth(env).user(env.params.query)

        user = ::User.where { _uid == social_auth_user.uid }.first
        ::User.create({:uid => social_auth_user.uid, :email => social_auth_user.email}) unless user

        env.session.string("uid", social_auth_user.uid)

        env.redirect("/")
      end

      # TODO: SPECS !!!
      get "/#{NAMESPACE}/logout" do |env|
        env.session.destroy

        env.redirect "/"
      end

      get "/#{NAMESPACE}/status" do |env|
        render_json({:authenticated => !env.session.string?("uid").nil?})
      end

      get "/#{NAMESPACE}/csrf_token" do |env|
        render_json({:csrfToken => env.session.string?("csrf")})
      end
    end
  end
end
