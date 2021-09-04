module Pulse
  module Ecs
    module Systems
      class SpatialPartitioning < Fast::ECS::System
        def initialize(state : Pulse::State::ApplicationState)
          @state = state
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(Location, Transform) do |query_set|
            location, transform = query_set
            update_map(location, transform)
            update_or_create_nearby_characters_component(location, transform)
          end
        end

        def destroy
          # TODO: ...
        end

        private def update_map(location, transform)
          current_map = state.maps[location.current_map_name]
          current_map.update_map(transform.position.x, transform.position.y, transform.id)
        end

        private def update_or_create_nearby_characters_component(location, transform)
          nearby_characters = find_or_create_nearby_characters_component(transform.id)
          updated_nearby_set = SparseSet::SparseSet.new
          current_map = state.maps[location.current_map_name]
          current_map.nearby_characters(transform.position.x, transform.position.y) do |character_entity_id|
            updated_nearby_set.add(character_entity_id) unless character_entity_id == transform.id
          end
          nearby_characters.entity_ids_set = updated_nearby_set
        end

        private def find_or_create_nearby_characters_component(entity_id)
          nearby_characters = engine.get_component(NearbyCharacters, entity_id)
          return create_nearby_characters_component(entity_id) if nearby_characters.nil?

          nearby_characters
        end

        private def create_nearby_characters_component(entity_id)
          nearby_characters = Pulse::Ecs::Component::NearbyCharacters.new(entity_id: entity_id)
          engine.add_component(nearby_characters)
        end
      end
    end
  end
end
