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

macro pulse_render(view, layout = nil)
  {% base_view_path = "src/views" %}

  {% if layout == nil %}
    render "#{{{base_view_path}}}/#{{{view}}}.ecr"
  {% else %}
    render "#{{{base_view_path}}}/#{{{view}}}.ecr", "#{{{base_view_path}}}/layouts/#{{{layout}}}.ecr"
  {% end %}
end

get "/" do |env|
  # TESTING session
  env.session.string("testy_session_stringy", "wowser123")
  env.session.string("testy_session_stringy1", "wowser123")
  env.session.string("testy_session_stringy2", "wowser123")
  env.session.string("testy_session_stringy3", "wowser123")

  pulse_render "home", "default"
end

get "/session_test" do |env|
  env.session.string("testy_session_stringy") + 
  env.session.string("testy_session_stringy1") +
  env.session.string("testy_session_stringy2") +
  env.session.string("testy_session_stringy3")
end

# TODO: SPECS !!! # TODO: SPECS !!! # TODO: SPECS !!!
# AUTH >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# TODO: SPECS !!!
get "/multi_auth/:provider" do |env|
  env.redirect(multi_auth(env).authorize_uri("openid email profile"))
end

# TODO: SPECS !!!
get "/multi_auth/:provider/callback" do |env|
  social_auth_user = multi_auth(env).user(env.params.query)
  # p user.email
  # user

  # puts [1, 2, 3].to_json            
  # puts "#{{:x => 1, :y => 2}.to_json}"
  # user.raw_json
  # user.uid

  # TODO: find or create a user by this info and redirect to home page...

  # {:email => user.email, :uid => user.uid}.to_json

  # {:email => user.email, :uid => user.uid}

  user = User.where { uid == social_auth_user.uid}.first
  User.create({:uid => social_auth_user.uid, :email => social_auth_user.email}) unless user

  env.session.string("uid", social_auth_user.uid)

  env.redirect("/")
end

# TODO: SPECS !!!
get "/logout" do |env|
  env.session.destroy

  env.redirect "/" 
end
# AUTH <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

get "/players" do
  # "players..."
  # TODO: stop creating users here
  # User.create({:name => "testy #{Random.new.rand.to_s[..5]}", :current_map => "randy_1"}) # if there is validation error will get Jennifer::BadQuery exception
  # User.create({:name => "testy #{Random.new.rand.to_s[..5]}"}) # sets default :current_map => "hub_0"

  # name not unique test
  # User.create({:name => "testy"})
  # User.create({:name => "testy"}) # throws Jennifer::BadQuery => Exception: duplicate key value violates unique constraint "users_name_idx".

  # TODO: this needs to be streamed as page is scrolled...

  users = User.all
  # users = [] of String
  pulse_render "players/index", "default"
end

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

# TODO: 'groups' rather than 'clans'?
get "/clans" do
  "clans..."
end

get "/store" do
  "store..."
end

get "/account" do |env|
  env.redirect("/multi_auth/google") unless env.session.string("uid")

  user = User.where { _uid == env.session.string("uid") }.first

  pulse_render "account", "default"
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
