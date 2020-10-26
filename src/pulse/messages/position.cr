# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Position < Pulse::Messages::ApplicationMessage
      TYPE = 1_u8

      property :position_x, :position_y

      def initialize(message : Slice(UInt8))
        @position_x = 0
        @position_y = 0

        parse(message) do |io|
          @position_x = io.get_number
          @position_y = io.get_number
        end
      end

      def initialize(position_x : UInt16, position_y : UInt16)
        @position_x = position_x
        @position_y = position_y
      end

      def to_slice
        to_slice(TYPE) do |io|
          io.set_number(@position_x)
          io.set_number(@position_y)
        end
      end
    end
  end
end
