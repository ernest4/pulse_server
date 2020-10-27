# TODO: speecs!!!

module Pulse
  module State
    class Reducer
      def initialize(state : Pulse::State::ApplicationState)
        @state = state
      end

      def enter(client)
        puts "[Pulse] Client has entered: id = #{client.user.id}, name = #{client.user.name}"

        current_client_map = current_map(client)

        return if current_client_map.clients.any?(client)

        current_client_map.clients.push(client)

        serialized_enter_message = Pulse::Messages::Enter.new(client.user).to_slice
        serialized_position_message = Pulse::Messages::Position.new(
          x: client.user.last_x, y: client.user.last_y
        ).to_slice

        current_client_map.clients.each do |client|
          client.socket.send(serialized_enter_message) # notify room of new player entrance
          client.socket.send(serialized_position_message) # initial position
        end
      end

      def current_map(client)
        # @reducer.state.maps[@user.current_map]
        # current_map = client.user.current_map
  
        # TESTING...
        map_name = @state.maps.keys.first
        # client.user.update({current_map: map_name})
        client.user.current_map = map_name
        
        @state.maps.values.first
      end

      def close(client)
        client.close

        current_client_map = current_map(client)

        # @state.maps[client.user.current_map].clients.delete(client)

        current_client_map.clients.delete(client)

        serialized_exit_message = Pulse::Messages::Exit.new(client.user).to_slice

        current_client_map.clients.each do |client|
          client.socket.send(serialized_exit_message) # notify room of player exiting
        end
      end

      # TODO: keep track of how frequent the same messages are coming. The front end shouldn't send
      # messages faster than certain fps (20?) but players may try to hack and send faster. Just
      # discard any message more frequent than fps limit?
      def reduce(client, message)
        parsed_message = Pulse::Messages::Resolver.resolve(message)

        # TODO: validate the message
        # TODO: alter the @state state

        # TODO: simplify this. either dynamically choose methods or extract to methods
        # TODO: strip out puts messages in production, keep for debugging in development
        case parsed_message.class.to_s
        when Pulse::Messages::Move.to_s
          move(client, parsed_message)
        # TODO: rest ...
        # when Pulse::Messages::....to_s
        #   ...(client, parsed_message)
        else
          puts "[Pulse] Unrecognized message type #{parsed_message.class}"
        end
      end

      def move(client, parsed_message)
        puts "[Pulse] Got 'Position' message. Type: #{parsed_message.class}"

        last_received_time = client.last_received_time[Pulse::Messages::Position::TYPE]
        current_received_time = Time.utc
        delta_time = (last_received_time - current_received_time).milliseconds
        # Discard spammy messages
        return if delta_time < Pulse::Messages::Position::MIN_UPDATE_RATE

        client.last_received_time[Pulse::Messages::Position::TYPE] = current_received_time

        # TODO: validate or rather send the next valid position
        # wip access game map and check if can move and update pos accordingly !!!
        # TODO: use delta time in the calculation ?? (or maybe not?)
        current_client_map = current_map(client)
        new_position = current_client_map.move(client, parsed_message.direction)
        return if new_position == client.user.position # map determined can't change position ...

        client.user.position = new_position
        # client.user.save    ... ? maybe worker will do this periodically instead?
        serialized_position_message = Pulse::Messages::Position.new(new_position).to_slice
        
        current_client_map.clients.each do |client|
          client.socket.send(serialized_position_message) # updated position
        end
      end
    end
  end
end


    # # Maybe:
    # # broadcast_room(scope : String, message : Pulse::Message, include_yourself : false)
    # #  e.g. scopes SCOPE::ROOM => "room", SCOPE::CLAN => "clan", SCOPE::GLOBAL => "global", SCOPE::FACTION => "faction", SCOPE::PARTY => "party"
    # # end
    # def broadcast_map_except_yourself(message : Pulse::Messages::ApplicationMessage)
    #   # TODO: ...
    #   # current_map.clients.each do |client|
    #   #   client.socket.send(message) if client.user.name != @user.name
    #   # end
    # end