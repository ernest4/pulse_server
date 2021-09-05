
module Pulse
  module Ecs
    module Component
      class ClientMessageEvent < Fast::ECS::Component
        property :from_entity_id, :binary_message

        def initialize(entity_id : Int32, from_entity_id : Int32, binary_message : Slice(UInt8))
          super(entity_id)
          @from_entity_id = from_entity_id
          @binary_message = binary_message
        end
      end
    end
  end
end