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

      # TODO: hmm mybe can use yielf here instead ?!?!?
      def to_slice
        super

        set_bytes(@position_x)
        set_bytes(@position_y)

        finish_to_slice
      end

      def parse
        # @message_type = get_byte
        get_byte # get the type byte and move the reader pointer on to next value

        @position_x = get_number
        @position_y = get_number
        # ... = get_string

        self # return self
      end
    end
  end
end
