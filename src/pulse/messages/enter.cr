# TODO: specs !!!
require "./application_message"

module Pulse
  module Messages
    class Enter < Pulse::Messages::ApplicationMessage
      TYPE = 2_u8

      # TODO: enforce max name length to 12 chars max
      @name : String

      # property :name

      def initialize(message : Slice(UInt8))
        @name = ""

        parse(message) do |io|
          @name = io.get_string
        end
      end

      def initialize(user : Pulse::User)
        # @name = "Γεια σουκόσμ" # works ...
        @name = user.name
      end

      def to_slice
        to_slice(TYPE) do |io|
          io.set_string("#{@name}")
        end
      end
    end
  end
end
