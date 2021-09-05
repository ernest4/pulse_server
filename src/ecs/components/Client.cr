module Pulse
  module Ecs
    module Component
      class Client < Fast::ECS::Component
        property :socket, :uid

        def initialize(entity_id : Int32, socket : HTTP::WebSocket, uid : String)
          super(entity_id)
          @socket = socket
          @uid = uid
        end
      end
    end
  end
end
