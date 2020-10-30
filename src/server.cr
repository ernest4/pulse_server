require "./config/boot" # Bootstrap the app


# TODO:
# 1 add PG DB setup / connection
# 2 add kemal PG session set up

add_handler CSRF.new


# # initialize a pool of database connection:
# # TODO: wip ...
# postgres_connection_string = ENV["DATABASE_URL"]? || "postgres://postgres@localhost/pulse_server_development"
# Clear::SQL.init(postgres_connection_string, connection_pool_size: 5)

# connect to postgres, update url with your connection info (or perhaps use an ENV var)
# connection = DB.open "postgres://youruser:yourpassword@localhost/yourdb"

# TODO: see if you can switch from default memory engine to postgres later...
Kemal::Session.config do |config|
  # config.engine = Session::PostgresEngine.new(connection)
  config.cookie_name = "session_id"
  config.secret = ENV["SECRET"]
  config.gc_interval = 2.minutes # 2 minutes
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

macro pulse_render(view, layout = nil)
  {% base_view_path = "src/views" %}

  {% if layout == nil %}
    render "#{{{base_view_path}}}/#{{{view}}}.ecr"
  {% else %}
    render "#{{{base_view_path}}}/#{{{view}}}.ecr", "#{{{base_view_path}}}/layouts/#{{{layout}}}.ecr"
  {% end %}
end

get "/" do
  pulse_render "home", "default"
end

# TODO: ... set up auth endpoint, SSO Google
# and store the user info in session that can be accessed in websocket.
# .. "/..." do
#   # TODO: ...
# end



# get "/logout" do |env|
#   env.session.destroy
#   "You have been logged out."
#   env.redirect "/" # redirect to home page
# end

get "/players" do
  # "players..."
  User.create({:name => "testy #{Random.new.rand.to_s[..5]}"}) # if there is validation error will get Jennifer::BadQuery exception
  users = User.all
  # users = [] of String
  pulse_render "players/index", "default"
end

get "/players/new" do |env|
  pulse_render "players/new", "default"
end

post "/players/new" do |env|
  # TODO: create player record here in postgres with username and password
  # name = env.params.body["name"].as(String)

  # u = User.new
  # u.email = "test@example.com"
  # u.save!

  # user = User.new(
  #   name: env.params.body["username"],
  #   password: env.params.body["password"],
  #   password_confirmation: env.params.body["password_confirmation"]
  # )
  # user.save!

  # redirect to homepage where user can select character to create & enter the game
  
  # TODO: rescue failed to create exception and redirect to the /players/new form
# rescue ex : Pulse::Unauthorized
#   # TODO: ...
#   raise ex # just reraise for now...
end

get "/players/sign-in" do |env|
  pulse_render "players/sign_in", "default"
end

post "/players/sign-in" do |env|
  env.params.body["username"] + env.params.body["password"]
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
  pulse_render "test", "default"
end

get "/testy/:name" do |env|
  name = env.params.url["name"]
  pulse_render "testy", "default"
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
