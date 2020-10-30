# require "pg"
require "jennifer"
# require "jennifer/adapter/postgres"

require "./src/config/config"
require "./src/config/initializers/jennifer"
require "./src/db/migrations/*"
require "sam"
require "jennifer/sam"

load_dependencies "jennifer"

# Here you can define your tasks
# desc "with description to be used by help command"
# task "test" do
#   puts "ping"
# end

Sam.help
