# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Position < Pulse::Messages::ApplicationMessage
      TYPE = 2_u8
      MIN_UPDATE_RATE = 50 # ms, 20 fps

      property :x, :y

      def initialize(x : UInt16, y : UInt16)
        @x = x
        @y = y
      end

      def to_slice
        to_slice(TYPE) do |io|
          io.set_number(@x)
          io.set_number(@y)
        end
      end
    end
  end
end
