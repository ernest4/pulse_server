# TODO: speecs!!!

module Pulse
  module State
    class Reducer
      def initialize(state : Pulse::State::ApplicationState)
        @state = state
      end

      def reduce(client, message)
        parsed_message = Pulse::Messages::Resolver.resolve(message)

        # TODO: validate the message
        # TODO: alter the @state state

        case parsed_message.type
        when Pulse::Messages::Enter::TYPE
          puts "[Pulse] Got 'Enter' message. Type: #{parsed_message.type}"

          # TESTING: just echo back
          client.socket.send(parsed_message.to_slice)
        when Pulse::Messages::Position::TYPE
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
