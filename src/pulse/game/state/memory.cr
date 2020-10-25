# TODO: speecs!!!
require "./base"

module Pulse
  module Game
    module State
      class Memory < Pulse::Game::State::Base
        # @maps : Hash(String, Pulse::Map)
  
        def initialize
          # TODO: ...
          @maps = {} of String => Pulse::Map
        end
  
        def load!
          # TODO: ... load from files

          # TESTING ...
          test_map = Pulse::Map.new(width: 6, height: 6)
          @maps[test_map.name] = test_map
        end
      end
    end
  end
end
