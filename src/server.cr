require "kemal"
require "./pulse/map"
require "./pulse/client"

# TODO: set up production and test configs / config files etc...

# TODOO: rollbar !!!

# server_memory = 0

# TODO: user redis for game state storage as kemal wont be thread safe once Crystal drops
# true parallelism for fibers

# load the map data
maps = {} of String => Pulse::Map

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
  "playing..."
end

# TODO: secure against specific creds
get "/admin" do
  "server admin only..."
end

get "/testy/:name" do |env|
  name = env.params.url["name"]
  render "src/views/testy.ecr", "src/views/layouts/default.ecr"
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
  client.authenticate!
  client.enter_room(maps) # TODO: maybe pass maps as initialization param to client ???

  # clients.push(client)

rescue ex : Pulse::Unauthorized
  # TODO: ...
end


Kemal.run
