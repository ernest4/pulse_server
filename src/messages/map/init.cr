# TODO: specs !!!

module Pulse
  module Messages
    module Map
      class Init < Pulse::Messages::ApplicationMessage
        TYPE = 5_u8

        # @player_id : Int32

        def initialize(map : Pulse::Map)
          @map = map
        end

        def to_slice
          to_message_slice(TYPE) do |io|
            io.set_number(Pulse::Map::TILE_SIZE_IN_PX)
            # io.set_number(Pulse::Map::MAX_WORLD_SIZE_IN_PX)
            # io.set_number(Pulse::Map::MAX_WORLD_SIZE_IN_TILES)
            io.set_number(@map.width)
            io.set_number(@map.height)
            @map.tiles.flatten.each do |tile|
              io.set_number(tile)
            end
          end
        end
      end
    end
  end
end