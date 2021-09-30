# TODO: specs !!!

module Pulse
  module Messages
    class Ping < Pulse::Messages::ApplicationMessage
      TYPE = 0_u8

      def initialize
      end

      def to_slice
        to_message_slice(TYPE) do |io|
          io.set_string("ping")
        end
      end
    end
  end
end
