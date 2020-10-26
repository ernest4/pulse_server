# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Move < Pulse::Messages::ApplicationMessage
      TYPE = 1_u8

      @directional_key1 : UInt8
      @directional_key2 : UInt8

      # TODO: keys lookup table

      property :directional_key1, :directional_key2

      def initialize(message : Slice(UInt8))
        @directional_key1 = 0
        @directional_key2 = 0

        parse(message) do |io|
          @directional_key1 = io.get_byte
          @directional_key2 = io.get_byte
          # TODO: ... more - jump key? shift (run) key, ctrl (crouch) key?
        end
      end
    end
  end
end
