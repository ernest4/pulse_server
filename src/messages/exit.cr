# TODO: specs !!!

module Pulse
  module Messages
    class Exit < Pulse::Messages::ApplicationMessage
      TYPE = 4_u8

      @character_id : Int32
      @name : String # TODO: enforce max name length to 12 chars max

      def initialize(character : Pulse::Character)
        @character_id = character.id!
        @name = character.name
      end

      def to_slice
        to_message_slice(TYPE) do |io|
          io.set_number(@character_id)
          io.set_string("#{@name}")
        end
      end
    end
  end
end
