# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Enter < Pulse::Messages::ApplicationMessage
      TYPE = 1

      # property :name

      def initialize(user : Pulse::User)
        @name = user.name
      end

      def to_slice
        to_slice do |io| # parent.to_slice(&block) ...
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
