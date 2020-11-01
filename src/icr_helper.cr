# preload all this to get quick access to query DB
require "jennifer"
require "jennifer/adapter/postgres"
require "colorize"
require "log"
Jennifer::Config.read("./src/config/database.yml", "development")
Jennifer::Config.configure {|config| config.logger = Log.for("db, :info")}
require "./models/**";

# User.where { _name == "testy3" && _current_map == "mappy1"} # example query