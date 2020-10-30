require "jennifer"
require "colorize"
# require "logger"
require "log"

Jennifer::Config.read("./src/pulse/config/database.yml", Pulse::Config::ENVIRONMENT)

Jennifer::Config.configure do |conf|
  # conf.logger = Logger.new(STDOUT)
  
  # conf.logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
  #   io << datetime.colorize(:cyan) << ": \n" << message.colorize(:light_magenta)
  # end
  # conf.logger.level = Logger::DEBUG
  
  conf.logger = Log.for("db", :debug)
end
