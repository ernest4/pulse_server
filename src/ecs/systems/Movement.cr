module Pulse
  module Ecs
    module Systems
      class Movement < Fast::ECS::System
        def initialize(maps : Hash(String, Pulse::Map))
          @maps = maps
        end

        def start
          # TODO: ...
        end

        def update
          # 1. TODO: grab all the MoveMessage components and translate them to changes in velocity first

          # 2. apply velocity and check collisions on current map
          engine.query(Transform, Velocity, Location) do |query_set|
            handle_movement(query_set)
          end
        end

        def destroy
          # TODO: ...
        end

        private def handle_movement(query_set)
          transform, velocity, location = query_set

          current_map = @maps[location.name]

          new_position = get_new_position(transform, velocity)
          new_position = clip_position_to_world_bounds(new_position)

          # TODO: re-enable (rework) collision detection later...
          # if can_move_to?(current_map, new_position)
          #   transform.x = new_position.x
          #   transform.y = new_position.y
          # end

          transform.x = new_position.x
          transform.y = new_position.y
        end

        private def get_new_position(transform, velocity)
          seconds = engine.delta_time / 1000;

          new_x = transform.x + (velocity.x * seconds)
          new_y = transform.y + (velocity.y * seconds)
    
          {:x => new_x, :y => new_y}
        end

        # private def move(client, direction)
        #   speed = client.character.speed
        #   last_x = client.character.last_x
        #   last_y = client.character.last_y
    
        #   new_position = {:x => last_x, :y => last_y}
    
        #   case direction
        #   when Pulse::Messages::Move::LEFT
        #     new_position = {:x => last_x - speed, :y => last_y}
        #   when Pulse::Messages::Move::LEFT_TOP
        #     new_position = {:x => last_x - speed, :y => last_y - speed}
        #   when Pulse::Messages::Move::TOP
        #     new_position = {:x => last_x, :y => last_y - speed}
        #   when Pulse::Messages::Move::RIGHT_TOP
        #     new_position = {:x => last_x + speed, :y => last_y - speed}
        #   when Pulse::Messages::Move::RIGHT
        #     new_position = {:x => last_x + speed, :y => last_y}
        #   when Pulse::Messages::Move::RIGHT_BOTTOM
        #     new_position = {:x => last_x + speed, :y => last_y + speed}
        #   when Pulse::Messages::Move::BOTTOM
        #     new_position = {:x => last_x, :y => last_y + speed}
        #   when Pulse::Messages::Move::LEFT_BOTTOM
        #     new_position = {:x => last_x - speed, :y => last_y + speed}
        #   else
        #     puts "[Pulse] Unrecognized move direction #{direction}"
        #   end
    
        #   new_position = clip_position_to_world_bounds(new_position)
    
        #   last_position = {:x => last_x, :y => last_y}
        #   can_move_to?(new_position) ? new_position : last_position
        # end
    
        private def clip_position_to_world_bounds(map, position)
          {
            :x => position[:x].clamp(0, map.width * Pulse::Map::TILE_SIZE_IN_PX),
            :y => position[:y].clamp(0, map.height * Pulse::Map::TILE_SIZE_IN_PX)
          }
        end
    
        private def can_move_to?(map, position)
          tile_y = position[:y] // Pulse::Map::TILE_SIZE_IN_PX
          tile_x = position[:x] // Pulse::Map::TILE_SIZE_IN_PX
    
          tile = map.tiles[tile_y][tile_x]
    
          # TODO: use proper tile type numbers later...
          # tile == 0 || tile == 1 || tile == 2 || tile == 3 || tile == 4
          tile != 4
        end
      end
    end
  end
end
