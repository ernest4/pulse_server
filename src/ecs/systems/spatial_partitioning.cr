module Pulse
  module Ecs
    module Systems
      class SpatialPartitioning < Fast::ECS::System
        def initialize(world : Pulse::World)
          @world = world
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(ConnectionEvent, Location, Transform) do |query_set|
            connection_event, location, transform = query_set
            add_to_world(connection_event, location, transform)
            create_or_update_nearby_characters_component(connection_event, location, transform)
          end
        end

        def destroy
          # TODO: ...
        end

        # TODO: move this to world class?
        private def add_to_world(connection_event, location, transform)
          current_map = world.maps[location.current_map_name]

          # TODO: can probs move this to some map.add_character() method
          cell_x, cell_y = world_to_cell_coordinates(transform.position.x, transform.position.y, current_map.grid_size)
          current_map.cell(cell_x, cell_y).characters.add(connection_event.id) # TODO: units is sparse set
        end

        private def world_to_cell_coordinates(x, y, grid_size)
          # x = x // grid_size;
          # y = y // grid_size;
         
          # {x: x, y: y}

          [x // grid_size, y // grid_size]
        end

        private def create_or_update_nearby_characters_component(connection_event, location, transform)
          nearby_characters = find_or_create_nearby_characters_component(connection_event.id)

          # https://davidwalsh.name/3d-websockets
          # NOTE: not sure why the link above suggests comparing two lists, just replace them!
          # current_nearby_set = nearby_characters.entity_ids
          updated_nearby_set = SparseSet::SparseSet.new

          current_map = world.maps[location.current_map_name]
          cell_x, cell_y = world_to_cell_coordinates(transform.position.x, transform.position.y, current_map.grid_size)

          # TODO: move the double loop to world.cell(x,y).with_nearby_cells {|cell| cell}
          [cell_x - 1, cell_x, cell_x + 1].each do |current_cell_x|
            [cell_y - 1, cell_y, cell_y + 1].each do |current_cell_y|
              # TODO: the map.cell() should be able to handle coordinates out of bounds and just return nil for those instead of erroring out like arrays normally do
              current_map.cell(current_cell_x, current_cell_y).characters.stream do |character_entity_id|
                updated_nearby_set.add(character_entity_id) unless character_entity_id == connection_event.id
              end
            end
          end

          nearby_characters.entity_ids_set = updated_nearby_set
        end

        private def find_or_create_nearby_characters_component(entity_id)
          nearby_characters = engine.get_component(NearbyCharacters, entity_id)

          if nearby_characters.nil?
            nearby_characters = create_nearby_characters_component(entity_id)
          end

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
