# TODO: specs !!!

module Pulse
  module Messages
    class Move < Pulse::Messages::ApplicationMessage
      TYPE = 1_u8 # TODO: maybe send message types lookup as first message to client??

      # 8 directions:
      # no_value => 0
      LEFT = 1
      LEFT_TOP = 2
      TOP = 3
      RIGHT_TOP = 4
      RIGHT = 5
      RIGHT_BOTTOM = 6
      BOTTOM = 7
      LEFT_BOTTOM = 8

      @direction : UInt8

      # TODO: keys lookup table

      property :direction

      def initialize(message : Slice(UInt8))
        @direction = 0

        parse(message) do |io|
          @direction = io.get_byte
          # TODO: ... more - jump key? shift (run) key, ctrl (crouch) key?
        end
      end

      def to_slice
        # STUB
        Slice(UInt8).new(0)
      end
    end
  end
end
