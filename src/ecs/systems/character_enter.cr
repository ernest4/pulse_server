module Pulse
  module Ecs
    module Systems
      class CharacterEnter < Fast::ECS::System
        def initialize(world : Pulse::World)
          @world = world
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(ConnectionEvent, Name, Transform, Location, NearbyClients) do |query_set|
            handle_character_enter(query_set)
          end
        end

        def destroy
          # TODO: ...
        end

        private def handle_character_enter(query_set)
          connection_event, name, transform, location, nearby_characters = query_set
          character_entity_id = connection_event.id

          components = [] of Pulse::Ecs::Component::ServerMessage

          components.push(map_init_message(location.current_map_name, character_entity_id))

          nearby_characters.entity_ids_set.stream do |nearby_character_entity_id|
            # messages to inform others of self
            components.push(enter_message(character_entity_id, name, nearby_character_entity_id))
            components.push(position_message(character_entity_id, transform, nearby_character_entity_id))

            # messages to inform self of others
            nearby_character_name = engine.get_component(Name, nearby_character_entity_id)
            nearby_character_transform = engine.get_component(Transform, nearby_character_entity_id)

            components.push(enter_message(nearby_character_entity_id, nearby_character_name, character_entity_id))
            components.push(position_message(nearby_character_entity_id, nearby_character_transform, character_entity_id))
          end

          engine.add_components(components)
        end

        private def map_init_message(current_map_name, recipient_character_entity_id)
          Pulse::Ecs::Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            message: Pulse::Messages::MapInit.new(world.maps[current_map_name]),
            to_entity_id: recipient_character_entity_id
          )
        end

        private def enter_message(subject_character_entity_id, name, recipient_character_entity_id)
          Pulse::Ecs::Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            message: Pulse::Messages::Enter.new(subject_character_entity_id, name.name),
            to_entity_id: recipient_character_entity_id
          )
        end

        private def position_message(subject_character_entity_id, transform, recipient_character_entity_id)
          message = Pulse::Messages::Position.new(
            subject_character_entity_id, transform.position.x, transform.position.y
          )

          Pulse::Ecs::Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            message: message,
            to_entity_id: recipient_character_entity_id
          )
        end
      end
    end
  end
end
