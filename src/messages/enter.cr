# TODO: specs !!!

module Pulse
  module Messages
    class Enter < Pulse::Messages::ApplicationMessage
      TYPE = 3_u8

      @character_entity_id : Int32
      @character_name : String # TODO: enforce max name length to 12 chars max

      def initialize(character_entity_id, character_name)
        @character_entity_id = character_entity_id
        @character_name = character_name
      end

      def to_slice
        to_message_slice(TYPE) do |io|
          io.set_number(@character_entity_id)
          io.set_string("#{@character_name}")
        end
      end
    end
  end
end
