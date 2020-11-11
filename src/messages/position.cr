# TODO: specs !!!

module Pulse
  module Messages
    class Position < Pulse::Messages::ApplicationMessage
      TYPE = 2_u8
      MIN_UPDATE_RATE = 50 # ms, 20 fps

      @x : UInt16
      @y : UInt16

      property :x, :y

      # need to push player ID here...
      def initialize(x, y)
        @x = x.to_u16
        @y = y.to_u16
      end

      def initialize(position)
        @x = position[:x].to_u16
        @y = position[:y].to_u16
      end

      def to_slice
        to_message_slice(TYPE) do |io|
          io.set_number(@x)
          io.set_number(@y)
        end
      end
    end
  end
end
