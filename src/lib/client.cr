# TODO: speeecs ?!?!?

module Pulse
  class Client
    @socket : Pulse::Socket
    # @client_id : String
    @user : ::User
    @character : Pulse::Character
    # @last_received_time : Hash(String, Time)

    property :socket, :client_id, :user, :character, :last_received_time

    def initialize(socket, client_id)
      @socket = socket
      # @client_id = client_id # TODO: not needed as instance var??
      @user = ::User.where { _uid == client_id }.first! # ... probably good to have a ref to user??
      @character = Pulse::Character.new(@user.characters.first.id!)
      @last_received_time = {} of UInt8 => Time::Span
    # rescue ex : NilAssertionError
    #   # TODO: ...
    #   raise ex # just reraise for now...
    end

    # TODO: is this needed?
    # probably not...
    # def authenticate!
    #   # TODO: ...
    # end

    def close
      # TODO: clean up, save state etc.
      # inline save?
      # @character.save
      # or queue up sidekiq worker to save...
    end

    # TODO: ... wipp
    def initialize_socket(reducer)
      # TODO: may or may not use this, not as efficient as binary, even for regular chat...
      # socket.on_message do |message|
      # end

      @socket.on_binary do |message|
        reducer.reduce(self, message)
      end

      # TODO: queue async worker to read redis and save player progress to DB?
      # TODO: for now save straight to DB here ???
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

# would be nice to have socket io like abstraction here...
@socket.on(Pulse::Messages::Move) do |message|
   message # <- parsed message, JSON rather than class?  
end

# probs need own wrapper
module Pulse
  class Socket
    @socket : HTTP::WebSocket

    delegate on_message, on_close, to: @socket # simply delegate unless we want to override

    def initialize(socket)
      @socket = socket
    end

    def on(message_class : Pulse::Messages::ApplicationMessage)
      # TODO: get type
      # message_class::TYPE
      @socket.on_binary do |message|
        # reducer.reduce(self, message)
        parsed_message = Pulse::Messages::Resolver.resolve(message)
      end


      # hmmm, probably need some meta programming here... 
    end
  end
end