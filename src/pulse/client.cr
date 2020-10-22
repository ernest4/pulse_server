# TODO: speeecs ?!?!?
module Pulse
  class Client
    def initialize(socket : HTTP::WebSocket, client_id, maps)
      @socket = socket
      @client_id = client_id
      @maps = maps
      # @user = ... TODO: load user from DB
      # TODO: initialize socket (attach callbacks)
    end


    def enter_map
      # TODO: ...wip
      # current_map.clients.each do |client| # TODO: make a broadcast method on Pulse::Map
      #   @socket.send(Pulse::Message.build(["Enter", @user.name, @user.position_x, @user.position_y]))
      # end

      # current_map.clients.push(self)
    end

    def current_map
      @maps[@user.current_map]
    end

    def exit_map
      # TODO: ...
    end

    # Maybe: 
    # broadcast_room(scope : String, message : Pulse::Message, include_yourself : false)
    #  e.g. scopes SCOPE::ROOM => "room", SCOPE::CLAN => "clan", SCOPE::GLOBAL => "global", SCOPE::FACTION => "faction", SCOPE::PARTY => "party"
    # end
    def broadcast_map_except_yourself(message : Pulse::Message)
      # TODO: ...
      # current_map.clients.each do |client|
      #   client.socket.send(message) if client.user.name != @user.name
      # end
    end

    # TODO: ... wipp
    private def initialize_socket
      # TODO: may or may not use this, not as efficient as binary, even for regular chat...
      # @socket.on_message do |message|
      # end

      @socket.on_binary do |message|
        # TODO: wip...
        parsed_message = Pulse::Message.parse(message)
        Pulse::MessageReducer.reduce(parsed_message)
      end

      # TODO: queue async worker to read redis and save player progress too DB?
      # TODOL for now save straigth to DB here ???
      @socket.on_close do |_|
      #   # sockets.delete(socket)
      #   puts "Closing Socket: #{socket}"
      end
    end
  end
end

