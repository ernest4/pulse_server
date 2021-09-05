# TODO: speecs!!!

module Pulse
  module State
    class Memory < Pulse::State::ApplicationState
      property maps : Hash(String, Pulse::Map)

      def initialize
        @maps = {} of String => Pulse::Map
      end

      def load!
        # TODO: ... load from files ?!? CSV, to stream world info cell by cell?

        # TESTING ...
        # test_map = Pulse::Map.new(width: 6, height: 6)
        @maps["hub_0"] = Pulse::Map.new
      end
    end
  end
end
