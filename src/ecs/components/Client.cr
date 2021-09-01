module Pulse
  module Ecs
    module Component
      class Client < Base
        property :socket

        def initialize(entity_id : Int32, socket : HTTP::WebSocket)
          super(entity_id)
          @socket = socket
        end
      end
    end
  end
end
