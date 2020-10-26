# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Position < Pulse::Messages::ApplicationMessage
      TYPE = 1

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
        to_slice(TYPE) do |io| # parent.to_slice(&block) ...
          io.set_number(@position_x)
          io.set_number(@position_y)
        end
      end

      # # TODO: hmm maybe can use yield here instead ?!?!?
      # def parse
      #   # @message_type = get_byte
      #   get_byte # get the type byte and move the reader pointer on to next value

      #   @position_x = get_number
      #   @position_y = get_number
      #   # ... = get_string

      #   self # return self
      # end
    end
  end
end