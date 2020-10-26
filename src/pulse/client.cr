# TODO: speeecs ?!?!?
require "./messages/resolver"
require "./user"

module Pulse
  class Client
    @socket : HTTP::WebSocket
    @client_id : String
    @reducer : Pulse::State::Reducer

    property :socket, :client_id

    def initialize(socket, client_id, reducer)
      @reducer = reducer
      # @socket = initialize_socket(socket)
      @socket = socket
      @client_id = client_id 
      @user = Pulse::User.new(client_id)
    end

    def authenticate!
      # TODO: ...
    end

    def exit_map
      # TODO: ...
    end

    # Maybe:
    # broadcast_room(scope : String, message : Pulse::Message, include_yourself : false)
    #  e.g. scopes SCOPE::ROOM => "room", SCOPE::CLAN => "clan", SCOPE::GLOBAL => "global", SCOPE::FACTION => "faction", SCOPE::PARTY => "party"
    # end
    def broadcast_map_except_yourself(message : Pulse::Messages::ApplicationMessage)
      # TODO: ...
      # current_map.clients.each do |client|
      #   client.socket.send(message) if client.user.name != @user.name
      # end
    end

    # TODO: ... wipp
    def initialize_socket
      # TODO: may or may not use this, not as efficient as binary, even for regular chat...
      # socket.on_message do |message|
      # end

      @socket.on_binary do |message|
        @reducer.reduce(self, message)
      end

      # TODO: queue async worker to read redis and save player progress too DB?
      # TODO: for now save straigth to DB here ???
      # TODO: clean up game state etc.
      @socket.on_close do |_|
        #   # sockets.delete(socket)
        #   puts "Closing Socket: #{socket}"
      end
    end
  end
end
