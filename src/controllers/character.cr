# TODO: specs !?!?

module Pulse
  module Controller
    class Character < Pulse::ApplicationController
      NAMESPACE = "characters"

      get "/#{NAMESPACE}/" do
        # "players..."
        # TODO: stop creating users here
        # User.create({:name => "testy #{Random.new.rand.to_s[..5]}", :current_map => "randy_1"}) # if there is validation error will get Jennifer::BadQuery exception
        # User.create({:name => "testy #{Random.new.rand.to_s[..5]}"}) # sets default :current_map => "hub_0"
      
        # name not unique test
        # User.create({:name => "testy"})
        # User.create({:name => "testy"}) # throws Jennifer::BadQuery => Exception: duplicate key value violates unique constraint "users_name_idx".
      
        # TODO: this needs to be streamed as page is scrolled...
      
        characters = ::Character.all
        # users = [] of String
        pulse_render "characters/index", "default"
      end

      # TODO: secure against specific creds
      # get "/#{NAMESPACE}/" do
      #   "characters..."
      # end

      # TODO: characters CRUD >>>>>>>>>>>>>>>>>
      # get "/#{NAMESPACE}/new" do |env|
      #   pulse_render "players/new", "default"
      # end

      # ....
      #   # name = env.params.body["name"].as(String)

      #   # u = User.new
      #   # u.email = "test@example.com"
      #   # u.save!

      #   # user = User.new(
      #   #   name: env.params.body["username"],
      #   #   password: env.params.body["password"],
      #   #   password_confirmation: env.params.body["password_confirmation"]
      #   # )
      #   # user.save!

      #   # redirect to homepage where user can select character to create & enter the game

      #   # TODO: rescue failed to create exception and redirect to the /#{NAMESPACE}/new form
      post "/#{NAMESPACE}" do |env|
        authenticate_and_redirect
        # authenticate!

        name = env.params.body["name"].as(String)

        user = ::User.where { _uid == env.session.string("uid") }.first!
        ::Character.create!({:name => name, :user_id => user.id})

      # rescue ex : Pulse::Unauthorized
        # env.redirect("/play")
        render_json({:success => true, :template => "...wip..."})
      rescue ex : Jennifer::BadQuery
      # #   # TODO: ... return json error response
        render_json({:success => false, :message => ex.message})
      end

      # get "/#{NAMESPACE}/sign-in" do |env|
      #   pulse_render "players/sign_in", "default"
      # end

      # post "/#{NAMESPACE}/sign-in" do |env|
      #   env.params.body["username"] + env.params.body["password"]
      # end
      # TODO: characters CRUD <<<<<<<<<<<<<<<<

      # get "/#{NAMESPACE}/new" do |env|
      #   pulse_render "characters/new", "default"
      # end
    end
  end
end
