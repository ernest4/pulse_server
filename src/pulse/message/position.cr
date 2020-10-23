# TODO: specs !!!
module Pulse
  module Message
    class Position < Pulse::Message
      property :position_x, :position_y

      def initialize(position_x : UInt16, position_y : UInt16, message : Slice(UInt8))
        super(message)

        @position_x = position_x
        @position_y = position_y
      end

      # def to_slice
      #   # TODO: ... wip
      #   io_memory = IO::Memory.new

      # end

      def parse
        # @message_type = get_byte
        get_byte # get the type byte and move the reader pointer on to next value

        @position_x = get_number
        @position_y = get_number

        self # return self
      end
    end
  end
end
