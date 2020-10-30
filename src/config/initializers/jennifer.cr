require "jennifer"
require "jennifer/adapter/postgres"
require "colorize"
# require "logger"
require "log"

if ENV.has_key?("DATABASE_URL")
  Jennifer::Config.from_uri(ENV["DATABASE_URL"])
else
  Jennifer::Config.read("./src/config/database.yml", Pulse::Config::ENVIRONMENT)
end

Jennifer::Config.configure do |config|
  config.pool_size = ENV.has_key?("KEMAL_MAX_THREADS") ? ENV["KEMAL_MAX_THREADS"].to_i : 5
  # config.logger = Logger.new(STDOUT)
  
  # config.logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
  #   io << datetime.colorize(:cyan) << ": \n" << message.colorize(:light_magenta)
  # end
  # config.logger.level = Logger::DEBUG
  
  # config.logger.level = Pulse::Config::ENVIRONMENT == "development" ? :debug : :error
  # config.logger = Log.for("db", :debug)
  config.logger = Log.for("db", :info)
end
