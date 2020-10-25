# TODO: speecs!!!

module Pulse
  module Game
    module State
      class Reducer
        def initialize(game : Pulse::Game::State::Base)
          @game = game
        end
  
        def reduce(message)
          # TODO: switch case the message
          # TODO: validate the message
          # TODO: alter the @game state

          # TESTING echo back
        end
      end
    end
  end
end
