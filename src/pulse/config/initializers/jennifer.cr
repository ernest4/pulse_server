require "jennifer"
# require "jennifer/adapter/postgres"
require "colorize"
# require "logger"
require "log"

Jennifer::Config.read("./src/pulse/config/database.yml", Pulse::Config::ENVIRONMENT)
Jennifer::Config.from_uri(ENV["DATABASE_URL"]) if ENV.has_key?("DATABASE_URL")

Jennifer::Config.configure do |conf|
  # conf.logger = Logger.new(STDOUT)
  
  # conf.logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
  #   io << datetime.colorize(:cyan) << ": \n" << message.colorize(:light_magenta)
  # end
  # conf.logger.level = Logger::DEBUG
  
  # conf.logger.level = Pulse::Config::ENVIRONMENT == "development" ? :debug : :error
  conf.logger = Log.for("db", :debug)
end
