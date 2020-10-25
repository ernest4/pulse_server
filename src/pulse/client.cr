# TODO: speeecs ?!?!?
require "./message/resolver"

module Pulse
  class Client
    @socket : HTTP::WebSocket
    @client_id : String
    @reducer : Pulse::Game::State::Reducer

    def initialize(socket, client_id, reducer)
      @reducer = reducer
      @socket = initialize_socket(socket)
      @client_id = client_id
      # @user = ... TODO: load user from DB
    end

    def authenticate!
      # TODO: ...
    end


    def enter_map
      # TODO: ...wip
      # current_map.clients.each do |client| # TODO: make a broadcast method on Pulse::Map
      #   @socket.send(Pulse::Message.build([Pulse::Message::EVENTS["ENTER"], @user.name, @user.position_x, @user.position_y]))
      #   @socket.send(Pulse::Message::Enter.new.build(@user))
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
    def broadcast_map_except_yourself(message : Pulse::Message::Base)
      # TODO: ...
      # current_map.clients.each do |client|
      #   client.socket.send(message) if client.user.name != @user.name
      # end
    end

    # TODO: ... wipp
    def initialize_socket(socket)
      # TODO: may or may not use this, not as efficient as binary, even for regular chat...
      # socket.on_message do |message|
      # end

      socket.on_binary do |message|
        # TODO: wip...
        # parsed_message = Pulse::Message::Base.new(message).parse
        parsed_message = Pulse::Message::Resolver.resolve(message)
        # TODO: push message to Game object to handle everyting maybe?
        # Pulse::MessageReducer.reduce(parsed_message)
        @reducer.reduce(parsed_message)
      end

      # TODO: queue async worker to read redis and save player progress too DB?
      # TODOL for now save straigth to DB here ???
      socket.on_close do |_|
      #   # sockets.delete(socket)
      #   puts "Closing Socket: #{socket}"
      end

      socket
    end
  end
end

