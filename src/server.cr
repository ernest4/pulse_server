require "./config/boot" # Bootstrap the app

# TODO:
# 2 add kemal PG session set up ??

add_handler CSRF.new

# TODO: switch away from memory store !!!
# Example of why it's bad in NODE.js and most likely other ENVs
# Warning The default server-side session storage, MemoryStore, is purposely not designed for a
# production environment. It will leak memory under most conditions, does not scale past a single
# process, and is meant for debugging and developing.
# Try get redis session working or postgres...
Kemal::Session.config do |config|
  # config.engine = Session::PostgresEngine.new(connection)
  config.cookie_name = "pulse_session"
  config.secret = ENV["SECRET"]
  config.gc_interval = 2.minutes # 2 minutes
  config.secure = Pulse::Config.production?
end

Kemal.config do |config|
  # if you disable logging, can get x2 to x3 times speed boost. Mostly overkill as heroku can only
  # handle 10k concurrent requests and kemal should by default might do as much...
  # config.logging = false
end

# This just doesnt seem to work with post endpoint??
# before_all do |env|
#   if Pulse::Config.development?
#     env.response.headers["Access-Control-Allow-Credentials"] = false
#     env.response.headers["Access-Control-Allow-Origin"] = "*"
#     env.response.headers["Access-Control-Allow-Methods"] = "GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH"
#     env.response.headers["Access-Control-Allow-Headers"] = "Connection,X-Powered-By,Content-Type,Content-Length,Set-Cookie,Set-Cookie"
#     env.response.headers["Access-Control-Expose-Headers"] = "Connection, X-Powered-By, Content-Type, Content-Length, Set-Cookie, Set-Cookie"
#   end

#   puts "cors all set"
# end

# get "/test" do
#   # TODO: only accessible in develop !!
#   Pulse::ApplicationController.pulse_render "test", "default"
# end

get "/test/:name" do |env|
  name = env.params.url["name"]
  Pulse::ApplicationController.pulse_render "testy", "default"
end

# TODO: clearly state alpha and then later beta stage of the game!

# NOTE: for single-shard world
# TODO: set up shared Redis between heroku apps. https://devcenter.heroku.com/articles/heroku-redis#sharing-heroku-redis-between-applications
# TODO: set up shared postgresql between heroku apps. https://devcenter.heroku.com/articles/heroku-postgresql#sharing-heroku-postgres-between-applications
# Basically the world is split up, by each server running specific section of the world.
# But DB is shared, so game world is shared and any player can go anywhere.

# TODO: set up production and test configs / config files etc...

# TODO: rollbar !!!
# TODO: need to implement globally caching exceptions since the existing crystal shard might not do
# it. Simply try to put a try catch block at highest level...

# TODO: user redis for game state storage

# TODO: sidekiq - set it up https://www.mikeperham.com/2016/05/25/sidekiq-for-crystal/

# load the map data. initialize global state etc
# maps = {} of String => Pulse::Map
# game_state = Pulse::State::Memory.new # TODO: dynamically swap between memory and redis based on env config !! (waiting to get config done ...)
# game_state.load!
# reducer = Pulse::State::Reducer.new(game_state)

game = Pulse::Game.new
game.start

# TODO: need to implement automatic Ping of client sockets to check if alive and clean them up out
# of memory if the connection dead...

# TODO: push thus into system
ws "/" do |socket, env|
#   # sockets have access to session...
#   # puts env.session.int?("hello")
#   # puts context.session.strings #returns {}
#   # puts context.response.cookies #correctly returns the cookie

#   # TODO: read from session
#   client = Pulse::Client.new(socket: socket, client_id: env.session.string("uid"))
#   # client = Pulse::Client.new(socket: socket, client_id: Random::Secure.hex) # random id for testing
#   # client.authenticate!
#   client.initialize_socket(reducer)
#   # client.enter_map


# # rescue ex : Pulse::Unauthorized
# #   # TODO: ...
# #   raise ex # just reraise for now...
end

Kemal.run
