# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Move < Pulse::Messages::ApplicationMessage
      TYPE = 1_u8

      # 8 directions:
      # no_value => 0
      # left => 1
      # left_top => 2
      # top => 3
      # right_top => 4
      # right => 5
      # right_bottom => 6
      # bottom => 7
      # left_bottom => 8
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
    end
  end
end
