module Pulse
  module Ecs
    module Component
      class Transform < Fast::ECS::Component
        property position : Ecs::Utils::Vector3
        property rotation : Ecs::Utils::Vector3
        property scale : Ecs::Utils::Vector3

        def initialize(entity_id : Int32, position_x = 0, position_y = 0, position_z = 0, rotation_x = 0, rotation_y = 0, rotation_z = 0, scale_x = 0, scale_y = 0, scale_z = 0)
          super(entity_id)
          @position = Ecs::Utils::Vector3.new(position_x, position_y, position_z)
          @rotation = Ecs::Utils::Vector3.new(rotation_x, rotation_y, rotation_z)
          @scale = Ecs::Utils::Vector3.new(scale_x, scale_y, scale_z)
        end
      end
    end
  end
end
