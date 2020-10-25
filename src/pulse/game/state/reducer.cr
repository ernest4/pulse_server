# TODO: speecs!!!

module Pulse
  module Game
    module State
      class Reducer
        def initialize(game : Pulse::Game::State::Base)
          @game = game
        end
  
        def reduce(client, message)
          parsed_message = Pulse::Message::Resolver.resolve(message)

          # TODO: validate the message
          # TODO: alter the @game state

          
          case parsed_message.type
          when Pulse::Message::Enter::TYPE
            puts "[Pulse] Got 'Enter' message. Type: #{parsed_message.type}"

            # TESTING: just echo back
            client.socket.send(parsed_message.to_slice)
          when Pulse::Message::Position::TYPE
            puts "[Pulse] Got 'Position' message. Type: #{parsed_message.type}"

            # TESTING: just echo back
            client.socket.send(parsed_message.to_slice)
          # when
          # TODO: .... the rest
          else
            puts "[Pulse] Unrecognized message type #{parsed_message.type}"
          end
        end
      end
    end
  end
end
