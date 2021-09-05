module Pulse
  module Ecs
    module Component
      class PhysicsBody < Fast::ECS::Component
        property linear_velocity : Ecs::Utils::Vector3
        property angular_velocity : Ecs::Utils::Vector3

        def initialize(entity_id : Int32, linear_velocity_x = 0, linear_velocity_y = 0, linear_velocity_z = 0, angular_velocity_x = 0, angular_velocity_y = 0, angular_velocity_z = 0)
          super(entity_id)
          @linear_velocity = Ecs::Utils::Vector3.new(linear_velocity_x, linear_velocity_y, linear_velocity_z)
          @angular_velocity = Ecs::Utils::Vector3.new(angular_velocity_x, angular_velocity_y, angular_velocity_z)
        end
      end
    end
  end
end
