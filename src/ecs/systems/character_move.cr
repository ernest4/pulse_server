module Pulse
  module Ecs
    module Systems
      class CharacterMove < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(Component::ClientMoveMessage) do |query_set|
            client_move_message = query_set.first.as Component::ClientMoveMessage
            handle_position_change(client_move_message)
          end
        end

        def destroy
          # TODO: ...
        end

        private def handle_position_change(client_move_message)
          transform = engine.get_component(Component::Transform, client_move_message.from_entity_id).as Component::Transform
          nearby_characters = engine.get_component(Component::NearbyCharacters, client_move_message.from_entity_id).as Component::NearbyCharacters
            
          server_message_components = [] of Component::ServerMessage
          server_message_components.push(position_message(transform, transform.id))

          nearby_characters.entity_ids_set.stream do |entity_id_item|
            nearby_character_entity_id = entity_id_item.id
            server_message_components.push(position_message(transform, nearby_character_entity_id))
          end

          engine.add_components(server_message_components)
        end

        private def position_message(transform, recipient_character_entity_id)
          Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            to_entity_id: recipient_character_entity_id,
            message: Pulse::Messages::Position.new(transform.id, transform.position.x, transform.position.y)
          )
        end
      end
    end
  end
end
