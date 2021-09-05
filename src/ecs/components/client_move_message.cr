
module Pulse
  module Ecs
    module Component
      class ClientMoveMessage < Fast::ECS::Component
        property :from_entity_id, :message

        def initialize(entity_id : Int32, from_entity_id : Int32, message : Pulse::Messages::Move)
          super(entity_id)
          @from_entity_id = from_entity_id
          @message = message
        end
      end
    end
  end
end