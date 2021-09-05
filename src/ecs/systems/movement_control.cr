module Pulse
  module Ecs
    module Systems
      class MovementControl < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # ...
        end

        def update
          apply_move_message
        end

        def destroy
          # TODO: ...
        end

        private def apply_move_message
          engine.query(Component::ClientMoveMessage) do |query_set|
            client_move_message = query_set.first.as Component::ClientMoveMessage
            
            physics_body = engine.get_component(Component::PhysicsBody, client_move_message.from_entity_id).as Component::PhysicsBody
            speed = engine.get_component(Component::Speed, client_move_message.from_entity_id).as Component::Speed

            direction = client_move_message.message.direction
            new_linear_velocity = calculate_new_linear_velocity(speed.units, direction)

            physics_body.linear_velocity.x = new_linear_velocity[:x]
            physics_body.linear_velocity.y = new_linear_velocity[:y]
          end
        end

        private def calculate_new_linear_velocity(speed, direction)
          new_linear_velocity = {:x => 0, :y => 0}

          case direction
          when Pulse::Messages::Move::LEFT
            new_linear_velocity = {:x => -speed, :y => 0}
          when Pulse::Messages::Move::LEFT_TOP
            new_linear_velocity = {:x => -speed, :y => -speed}
          when Pulse::Messages::Move::TOP
            new_linear_velocity = {:x => 0, :y => -speed}
          when Pulse::Messages::Move::RIGHT_TOP
            new_linear_velocity = {:x => speed, :y => -speed}
          when Pulse::Messages::Move::RIGHT
            new_linear_velocity = {:x => speed, :y => 0}
          when Pulse::Messages::Move::RIGHT_BOTTOM
            new_linear_velocity = {:x => speed, :y => speed}
          when Pulse::Messages::Move::BOTTOM
            new_linear_velocity = {:x => 0, :y => speed}
          when Pulse::Messages::Move::LEFT_BOTTOM
            new_linear_velocity = {:x => -speed, :y => speed}
          end

          new_linear_velocity
        end
      end
    end
  end
end
