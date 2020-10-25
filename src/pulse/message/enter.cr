# TODO: specs !!!
require "./base"

module Pulse
  module Message
    class Enter < Pulse::Message::Base
      TYPE = 1
      
      # property :name

      def initialize(message : Slice(UInt8))
        super(message)
      end

      def initialize(user)
        @name = user.name
      end

      def to_slice
        super.to_slice do |io|
          io.set_byte(TYPE)
          io.set_string("#{@name}")
        end
      end

      # TODO: hmm maybe can use yield here instead ?!?!?
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
