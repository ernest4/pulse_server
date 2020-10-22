module Pulse
  class Client
    def initialize(socket : HTTP::WebSocket, client_id)
      @socket = socket
    end

    def enter_room
      # TODO: ...
    end
  end
end
