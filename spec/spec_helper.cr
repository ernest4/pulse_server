ENV["SECRET"] = "123"
ENV["KEMAL_ENV"] = "test"


# require "spec"
require "spec-kemal"
require "spectator" # more RSpec like expectations. Preferred over "spec"
require "../src/server"

