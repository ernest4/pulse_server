# TODO: speecs!!!

module Pulse
  module State
    class Memory < Pulse::State::ApplicationState
      # @maps : Hash(String, Pulse::Map)

      # property :maps : Hash(String, Pulse::Map)
      # setter :maps

      def initialize
        # TODO: ...
        @maps = {} of String => Pulse::Map
      end

      def maps : Hash(String, Pulse::Map)
        @maps
      end

      def load!
        # TODO: ... load from files ?!?

        # TESTING ...
        # test_map = Pulse::Map.new(width: 6, height: 6)
        test_map = Pulse::Map.new
        @maps[test_map.name] = test_map
      end
    end
  end
end
