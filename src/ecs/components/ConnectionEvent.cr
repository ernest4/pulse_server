module Pulse
  module Ecs
    module Component
      class ConnectionEvent < Base
        property :socket, :uuid
        # serialize :uuid # <- this comes from Pulse::Ecs::Component::Base

        def initialize(entity_id : Int32, socket : HTTP::WebSocket, uuid : String)
          super(entity_id)
          @socket = socket
          @uuid = uuid
        end
      end
    end
  end
end