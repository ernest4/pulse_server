module Pulse
  module Ecs
    module Systems
      class Movement < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(Component::Transform, Component::PhysicsBody) do |query_set|
            handle_movement(query_set)
          end
        end

        def destroy
          # TODO: ...
        end

        private def handle_movement(query_set)
          transform, physics_body = Tuple(Component::Transform, Component::PhysicsBody).from(query_set)

          seconds = engine.delta_time / 1000;

          # TODO: maybe divide by 10 here, keep the int and divide by // 100 (truncate) on client side as well?
          # seconds = engine.delta_time // 10;

          transform.position.x += physics_body.linear_velocity.x * seconds
          transform.position.y += physics_body.linear_velocity.y * seconds

          transform.rotation.z += physics_body.angular_velocity.z * seconds
          transform.rotation.z = transform.rotation.z - 360 if 360 < transform.rotation.z 
        end
      end
    end
  end
end
