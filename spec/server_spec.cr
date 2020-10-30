require "./spec_helper"

# TODO: migrate to RSpec style expect() https://github.com/icy-arctic-fox/spectator

describe "Your::Kemal::App" do
  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should contain "<title>Multiplayer Application</title>"
  end
end
