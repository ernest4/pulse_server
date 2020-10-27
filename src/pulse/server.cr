require "kemal"
require "./map"
require "./client"
require "./exceptions/unauthorized"
require "./state/memory"
require "./state/reducer"

# require "clear"

# # initialize a pool of database connection:
# # TODO: wip ...
# Clear::SQL.init("postgres://postgres@localhost/my_database", connection_pool_size: 5)





# TODO: clearly state alpha and then later beta stage of the game!

# NOTE: for single-shard world
# TODO: set up shared Redis between heroku apps. https://devcenter.heroku.com/articles/heroku-redis#sharing-heroku-redis-between-applications
# TODO: set up shared postgresql between heroku apps. https://devcenter.heroku.com/articles/heroku-postgresql#sharing-heroku-postgres-between-applications
# Basically the world is split up, by each server running specific section of the world.
# But DB is shared, so game world is shared and any player can go anywhere.

# TODO: set up production and test configs / config files etc...

# TODOO: rollbar !!!

# server_memory = 0

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

get "/" do
  # server_memory = server_memory + 1
  # "Hello World! #{server_memory}"
end

# TODO: ... set up auth endpoint, SSO Google
# and store the user info in session that can be accessed in websocket.
# .. "/..." do
#   # TODO: ...
# end



# get "/logout" do |env|
#   env.session.destroy
#   "You have been logged out."
# end

get "/players" do
  "players..."
end

# TODO: 'groups' rather than 'clans'?
get "/clans" do
  "clans..."
end

get "/store" do
  "store..."
end

get "/account" do
  "account..."
end

get "/play" do
  # TODO: check this server and other server capacities and load balance (redirect) to other server
  # if needed.
  "playing..."
end

# TODO: secure against specific creds
get "/admin" do
  "server admin only..."
end

get "/test" do
  # TODO: only accessible in develop !!
  render "src/pulse/views/test.ecr", "src/pulse/views/layouts/default.ecr"
end

get "/testy/:name" do |env|
  name = env.params.url["name"]
  render "src/pulse/views/testy.ecr", "src/pulse/views/layouts/default.ecr"
end


# WARNING: if crystal releases parallel update, fibers will access local data async !!!
# Therefore if using in memory data, do no upgrade crystal version as fibers concurrency will be
# default !!!
# messages = [] of String
# sockets = [] of HTTP::WebSocket
# clients = [] of Pulse::Client

ws "/" do |socket, env|
  # sockets have access to session...
  # puts env.session.int?("hello")
  # puts context.session.strings #returns {}
  # puts context.response.cookies #correctly returns the cookie

  # TODO: read from session
  # client = Client.new(:socket => socket, :session_id => session_id)
  client = Pulse::Client.new(socket: socket, client_id: Random::Secure.hex) # random id for testing
  client.initialize_socket(reducer)
  client.authenticate!
  # client.enter_map
rescue ex : Pulse::Unauthorized
  # TODO: ...
  raise ex # just reraise for now...
end


Kemal.run
