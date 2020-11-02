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
      # get "/players/new" do |env|
      #   pulse_render "players/new", "default"
      # end

      # post "/players/new" do |env|
      #   # TODO: create player record here in postgres with username and password
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

      #   # TODO: rescue failed to create exception and redirect to the /players/new form
      # # rescue ex : Pulse::Unauthorized
      # #   # TODO: ...
      # #   raise ex # just reraise for now...
      # end

      # get "/players/sign-in" do |env|
      #   pulse_render "players/sign_in", "default"
      # end

      # post "/players/sign-in" do |env|
      #   env.params.body["username"] + env.params.body["password"]
      # end
      # TODO: characters CRUD <<<<<<<<<<<<<<<<
    end
  end
end
