# TODO: specs !!!
require "./position"

module Pulse
  module Message
    module Resolver
      extend self

      MESSAGE_TYPE_CLASSES = {
        # 0 => Classy
        # 1 => Pulse::Message::Enter,
        2 => Pulse::Message::Position, # if player sends this, resend this back to player to acknowledge it as validated
        # TODO: attack... # if player sends this, resend this back to player to acknowledge it as validated
        # TODO: die...
        # TODO: drop item... # if player sends this, resend this back to player to acknowledge it as validated
        # TODO: pick up item... # if player sends this, resend this back to player to acknowledge it as validated
        # TODO: use item... (drinking potion, cast spell, put on armour, spend gold etc) # if player sends this, resend this back to player to acknowledge it as validated
      }

      def resolve(message)
        io_memory_message = IO::Memory.new(message)
        class_type = io_memory_message.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        MESSAGE_TYPE_CLASSES[class_type].new(message: message).parse
      end
    end
  end
end
