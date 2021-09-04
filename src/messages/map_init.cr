# TODO: specs !!!

module Pulse
  module Messages
    class MapInit < Pulse::Messages::ApplicationMessage
      TYPE = 5_u8

      def initialize(map : Pulse::Map)
        @map = map
      end

      def to_slice
        to_message_slice(TYPE) do |io|
          io.set_number(Pulse::Map::TILE_SIZE_IN_PX) # u8
          # io.set_number(Pulse::Map::MAX_WORLD_SIZE_IN_PX) # u16
          # io.set_number(Pulse::Map::MAX_WORLD_SIZE_IN_TILES) # u16
          io.set_number(@map.width) # u16
          io.set_number(@map.height) # u16
          @map.tiles.flatten.each do |tile|
            io.set_number(tile) # u16
          end
        end
      end
    end
  end
end

