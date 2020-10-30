ENV["SECRET"] = "123"
ENV["KEMAL_ENV"] = "test"


# require "spec"
require "spec-kemal"
require "spectator" # more RSpec like expectations. Preferred over "spec"
require "../src/server"

# Spec.before_each do
#   Jennifer::Adapter.default_adapter.begin_transaction
# end

# Spec.after_each do
#   Jennifer::Adapter.default_adapter.rollback_transaction
# end
