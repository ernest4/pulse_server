module Pulse
  module Ecs
    module Component
      class Character < Fast::ECS::Component
        def initialize(entity_id : Int32)
          super(entity_id)
        end
      end
    end
  end
end
