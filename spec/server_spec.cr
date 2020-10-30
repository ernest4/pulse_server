require "./spec_helper"

# describe "Your::Kemal::App" do
#   # You can use get,post,put,patch,delete to call the corresponding route.
#   it "renders /" do
#     get "/"
#     response.body.should contain "<title>Multiplayer Application</title>"
#   end
# end

Spectator.describe "Pulse Server" do
  # You can use get,post,put,patch,delete to call the corresponding route.
  before_each { get "/" }

  it "renders /" do
    expect(response.body).to contain "<title>Multiplayer Application</title>"
  end
end
