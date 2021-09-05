module Pulse
  module Ecs
    module Systems
      class Collision < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(Component::Transform) { |query_set| handle_collision(query_set) }
        end

        def destroy
          # TODO: ...
        end

        private def handle_collision(query_set)
          transform = query_set.first

          # TODO: ...
          # TODO: takes in transform and checks it against map. Might be useful to store 'previous' values on Transform (that get auto updated) so in case of collision Transform could be reverted to that?# TODO: takes in transform and checks it against map. Might be useful to store 'previous' values on Transform (that get auto updated) so in case of collision Transform could be reverted to that?
        end
      end
    end
  end
end


# private def clip_position_to_world_bounds(map, position)
#   {
#     :x => position[:x].clamp(0, map.width * Pulse::Map::TILE_SIZE_IN_PX),
#     :y => position[:y].clamp(0, map.height * Pulse::Map::TILE_SIZE_IN_PX)
#   }
# end

# private def can_move_to?(map, position)
#   tile_y = position[:y] // Pulse::Map::TILE_SIZE_IN_PX
#   tile_x = position[:x] // Pulse::Map::TILE_SIZE_IN_PX

#   tile = map.tiles[tile_y][tile_x]

#   # TODO: use proper tile type numbers later...
#   # tile == 0 || tile == 1 || tile == 2 || tile == 3 || tile == 4
#   tile != 4
# end