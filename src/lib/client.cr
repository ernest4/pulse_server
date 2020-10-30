# TODO: speeecs ?!?!?

module Pulse
  class Client
    @socket : HTTP::WebSocket
    @client_id : String
    # @last_received_time : Hash(String, Time)

    property :socket, :client_id, :user, :last_received_time

    def initialize(socket, client_id)
      @socket = socket
      @client_id = client_id 
      @user = Pulse::User.new(client_id)
      @last_received_time = {} of UInt8 => Time::Span
    end

    def authenticate!
      # TODO: ...
    end

    def close
      # TODO: clean up, save state etc.
    end

    # TODO: ... wipp
    def initialize_socket(reducer)
      # TODO: may or may not use this, not as efficient as binary, even for regular chat...
      # socket.on_message do |message|
      # end

      @socket.on_binary do |message|
        reducer.reduce(self, message)
      end

      # TODO: queue async worker to read redis and save player progress too DB?
      # TODO: for now save straigth to DB here ???
      # TODO: clean up game state etc.
      @socket.on_close do |_|
        reducer.close(self)
        #   # sockets.delete(socket)
        #   puts "Closing Socket: #{socket}"
      end

      reducer.enter(self)
    end
  end
end
