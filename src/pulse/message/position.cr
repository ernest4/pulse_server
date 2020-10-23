# TODO: specs !!!
module Pulse
  module Message
    class Position < Pulse::Message
      property :position_x, :position_y

      def initialize(position_x : UInt16, position_y : UInt16)
        @position_x = position_x
        @position_y = position_y
      end

      # def to_slice
      #   # TODO: ... wip
      #   io_memory = IO::Memory.new

      # end

      def parse(message : Slice(UInt8))
        # TODO: extract info from message and populate instancs vars
        # TODO: return self
      end
    end
  end
end
