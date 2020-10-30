# TODO: specs !!!

module Pulse
  module Messages
    class Enter < Pulse::Messages::ApplicationMessage
      TYPE = 3_u8

      @player_id : Int32
      @name : String # TODO: enforce max name length to 12 chars max

      def initialize(user : Pulse::User)
        @player_id = user.id
        @name = user.name
      end

      def to_slice
        to_message_slice(TYPE) do |io|
          io.set_number(@player_id)
          io.set_string("#{@name}")
        end
      end
    end
  end
end
