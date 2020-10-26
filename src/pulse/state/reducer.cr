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

        # TODO: simplify this. either dynamically choose methods or extract to methods
        # TODO: strip out puts messages in production, keep for debugging in development
        case parsed_message.class
        when Pulse::Messages::Enter
          puts "[Pulse] Got 'Enter' message. Type: #{parsed_message.class}"

          current_client_map = current_map(client)
          current_client_map.clients.push(client)

          # TODO: ...wip
          current_client_map.clients.each do |client| # TODO: make a broadcast method on Pulse::Map
          # @socket.send(Pulse::Message.build([Pulse::Messages::EVENTS["ENTER"], @user.name, @user.position_x, @user.position_y]))
            client.socket.send(Pulse::Messages::Enter.new(client.user).to_slice)
            # client.socket.send(Pulse::Messages::Position.new(@user).to_slice) # TODO: send position stuff separate
          end

          # current_client_map.clients.push(client)

          # TESTING: just echo back
          client.socket.send(parsed_message.to_slice)
        when Pulse::Messages::Position
          puts "[Pulse] Got 'Position' message. Type: #{parsed_message.class}"

          # TESTING: just echo back
          client.socket.send(parsed_message.to_slice)
          # when
          # TODO: .... the rest
        else
          puts "[Pulse] Unrecognized message type #{parsed_message.class}"
        end
      end

      def current_map(client)
        # @reducer.state.maps[@user.current_map]
        # current_map = client.user.current_map
  
        # TESTING...
        @state.maps.values.first
      end
    end
  end
end
