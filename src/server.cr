require "./config/boot" # Bootstrap the app

# TODO:
# 2 add kemal PG session set up ??

add_handler CSRF.new

# TODO: see if you can switch from default memory engine to postgres later...
Kemal::Session.config do |config|
  # config.engine = Session::PostgresEngine.new(connection)
  config.cookie_name = "pulse_session"
  config.secret = ENV["SECRET"]
  config.gc_interval = 2.minutes # 2 minutes
  config.secure = Pulse::Config.production?
end

# TODO: clearly state alpha and then later beta stage of the game!

# NOTE: for single-shard world
# TODO: set up shared Redis between heroku apps. https://devcenter.heroku.com/articles/heroku-redis#sharing-heroku-redis-between-applications
# TODO: set up shared postgresql between heroku apps. https://devcenter.heroku.com/articles/heroku-postgresql#sharing-heroku-postgres-between-applications
# Basically the world is split up, by each server running specific section of the world.
# But DB is shared, so game world is shared and any player can go anywhere.

# TODO: set up production and test configs / config files etc...

# TODO: rollbar !!!

# TODO: user redis for game state storage as kemal wont be thread safe once Crystal drops
# true parallelism for fibers

# TODO: sidekiq

# load the map data. initialize global state etc
# maps = {} of String => Pulse::Map
game_state = Pulse::State::Memory.new # TODO: dynamically swap between memory and redis based on env config !! (waiting to get config done ...)
game_state.load!
reducer = Pulse::State::Reducer.new(game_state)

# TESTING >>>>>>>>
# ACTUALLY THIS MIGHT BE BAD APPROACH. SHOULD JUST UPDATE ASAP, BUT KEEP TRACK OF HOLD IT WAS SINCE
# LAST UPDATE...
# count = 0

# spawn do
#   loop do
#     sleep 0.05
#     puts "yay"
#     puts count = count + 1
#     puts Time.utc
#   end
# end
# TESTING <<<<<<<

get "/play" do
  # TODO: check this server and other server capacities and load balance (redirect) to other server
  # if needed.
  "playing..."
end

get "/test" do
  # TODO: only accessible in develop !!
  Pulse::ApplicationController.pulse_render "test", "default"
end

get "/test/:name" do |env|
  name = env.params.url["name"]
  Pulse::ApplicationController.pulse_render "testy", "default"
end

# WARNING: if crystal releases parallel update, fibers will access local data async !!!
# Therefore if using in memory data, do no upgrade crystal version as fibers concurrency will be
# default !!!

# TODO: need to implement automatic Ping of client sockets to check if alive and clean them up out
# of memory if the connection dead...

ws "/" do |socket, env|
  # sockets have access to session...
  # puts env.session.int?("hello")
  # puts context.session.strings #returns {}
  # puts context.response.cookies #correctly returns the cookie

  # TODO: read from session
  client = Pulse::Client.new(socket: socket, client_id: env.session.string("uid"))
  # client = Pulse::Client.new(socket: socket, client_id: Random::Secure.hex) # random id for testing
  client.initialize_socket(reducer)
  client.authenticate!
  # client.enter_map

rescue ex : Pulse::Unauthorized
  # TODO: ...
  raise ex # just reraise for now...
end

Kemal.config do |config|
  # if you disable logging, can get x2 to x3 times speed boost. Mostly overkill as heroku can only
  # handle 10k concurrent requests and kemal should by default might do as much...
  # config.logging = false
end

Kemal.run
