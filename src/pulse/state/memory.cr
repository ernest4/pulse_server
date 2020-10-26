# TODO: speecs!!!
require "./application_state"

module Pulse
  module State
    class Memory < Pulse::State::ApplicationState
      # @maps : Hash(String, Pulse::Map)

      property :maps

      def initialize
        # TODO: ...
        @maps = {} of String => Pulse::Map
      end

      def load!
        # TODO: ... load from files ?!?

        # TESTING ...
        test_map = Pulse::Map.new(width: 6, height: 6)
        @maps[test_map.name] = test_map
      end
    end
  end
end
