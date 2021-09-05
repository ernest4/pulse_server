
module Pulse
  module Ecs
    module Component
      class ServerMessage < Fast::ECS::Component
        property :to_entity_id, :message

        def initialize(entity_id : Int32, to_entity_id : Int32, message : Pulse::Messages::ApplicationMessage)
          super(entity_id)
          @to_entity_id = to_entity_id
          @message = message
        end
      end
    end
  end
end