module Pulse
  module Ecs
    module Systems
      class CharacterEnter < Fast::ECS::System
        def initialize(state : Pulse::State::ApplicationState)
          @state = state
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(Component::ConnectionEvent, Component::Name, Component::Transform, Component::Location, Component::NearbyCharacters) do |query_set|
            handle_character_enter(query_set)
          end
        end

        def destroy
          # TODO: ...
        end

        private def handle_character_enter(query_set)
          connection_event, name, transform, location, nearby_characters = Tuple(Component::ConnectionEvent, Component::Name, Component::Transform, Component::Location, Component::NearbyCharacters).from(query_set)
          character_entity_id = connection_event.id

          components = [] of Component::ServerMessage

          components.push(map_init_message(location.current_map_name, character_entity_id))

          nearby_characters.entity_ids_set.stream do |entity_id_item|
            nearby_character_entity_id = entity_id_item.id
            # messages to inform others of self
            components.push(enter_message(character_entity_id, name, nearby_character_entity_id))
            components.push(position_message(character_entity_id, transform, nearby_character_entity_id))

            # messages to inform self of others
            nearby_character_name = engine.get_component(Component::Name, nearby_character_entity_id).as Component::Name
            nearby_character_transform = engine.get_component(Component::Transform, nearby_character_entity_id).as Component::Transform

            components.push(enter_message(nearby_character_entity_id, nearby_character_name, character_entity_id))
            components.push(position_message(nearby_character_entity_id, nearby_character_transform, character_entity_id))
          end

          engine.add_components(components)
        end

        private def map_init_message(current_map_name, recipient_character_entity_id)
           Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            to_entity_id: recipient_character_entity_id,
            message: Pulse::Messages::MapInit.new(@state.maps[current_map_name])
          )
        end

        private def enter_message(subject_character_entity_id, name, recipient_character_entity_id)
           Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            to_entity_id: recipient_character_entity_id,
            message: Pulse::Messages::Enter.new(subject_character_entity_id, name.name)
          )
        end

        private def position_message(subject_character_entity_id, transform, recipient_character_entity_id)
          message = Pulse::Messages::Position.new(
            subject_character_entity_id, transform.position.x, transform.position.y
          )

           Component::ServerMessage.new(
            entity_id: engine.generate_entity_id,
            to_entity_id: recipient_character_entity_id,
            message: message
          )
        end
      end
    end
  end
end
