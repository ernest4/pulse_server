# TODO: speecs!!!

module Pulse
  module State
    class Reducer
      def initialize(state : Pulse::State::ApplicationState)
        @state = state
      end

      def enter(client)
        puts "[Pulse] Client has entered: user_id = #{client.user.id}, character_id = #{client.character.id}, name = #{client.character.name}"

        current_client_map = current_map(client)

        return if current_client_map.clients.any?(client)

        current_client_map.clients.push(client)

        # TODO: send the map data to client. Chunk / stream piece by piece if slow to bulk send
        # whole map?
        client.socket.send(Pulse::Messages::Map::Init.new(current_client_map).to_slice)

        messages = [
          Pulse::Messages::Enter.new(client.character),
          # TODO: before sending out position, validate that it's still walkable. Since user last
          # position might be blocked now, then need to find next closest free position (or spawn
          # point) instead and send that. Don't forget to save the new player position in that case!
          Pulse::Messages::Position.new(client.character),
        ]

        # Let everyone know of new character
        broadcast_map(current_client_map, messages)

        # Let new character know of everyone else
        current_client_map.clients.each do |other_client|
          # don't send yourself, you already did up there a moment ago...
          next if other_client.user.id == client.user.id

          client.socket.send(Pulse::Messages::Enter.new(other_client.character).to_slice)
          client.socket.send(Pulse::Messages::Position.new(other_client.character).to_slice)
        rescue ex : IO::Error
          # TODO: close client that's 'Exception: Closed stream (IO::Error)'
          # puts ex
          # raise ex
          close(client)
        end
      end

      def current_map(client)
        # TESTING...
        # map_name = @state.maps.keys.first
        # # client.character.update({current_map: map_name})
        # client.character.current_map = map_name

        # @state.maps.values.first

        @state.maps[client.character.current_map]
      end

      def close(client)
        client.close

        current_client_map = current_map(client)

        # @state.maps[client.character.current_map].clients.delete(client)

        current_client_map.clients.delete(client)

        broadcast_map(current_client_map, [Pulse::Messages::Exit.new(client.character)])
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
        puts "[Pulse] Got message. Type: #{parsed_message.class}"

        # TODO: !!! test to make sure this rate limiting of messages works !!!
        last_received_time = client.last_received_time[Pulse::Messages::Position::TYPE]? || Time::Span.new # Time::Span.new => time since epoch...
        # Time.monotonic should be used for time comparisons instead of Time.utc https://crystal-lang.org/api/0.35.1/Time.html#measuring-time
        current_received_time = Time.monotonic # => Time::Span
        delta_time = (current_received_time - last_received_time).total_milliseconds.to_i
        # Discard spammy messages
        return if delta_time < Pulse::Messages::Position::MIN_UPDATE_RATE

        client.last_received_time[Pulse::Messages::Position::TYPE] = current_received_time

        # TODO: validate or rather send the next valid position
        # wip access game map and check if can move and update pos accordingly !!!
        # TODO: use delta time in the calculation ?? (or maybe not?)
        current_client_map = current_map(client)
        new_position = current_client_map.move(client, parsed_message.direction)
        return if new_position == client.character.position # map determined can't change position ...

        puts new_position                        # testing
        puts client.character.position           # testing
        client.character.position = new_position # TODO: this isnt assignint it properly!!?!!
        puts client.character.position           # testing
        # client.character.save    ... ? maybe worker will do this periodically instead?

        broadcast_map(current_client_map, [Pulse::Messages::Position.new(client.character)])
      end

      def broadcast
        # TODO: to everyone in every map (everyone in the game)
        # loop over maps and call broadcast_map() on each...
      end

      def broadcast_map(map : Pulse::Map, messages : Array(Pulse::Messages::ApplicationMessage))
        serialized_messages = messages.map(&.to_slice)

        map.clients.each do |client|
          serialized_messages.each do |serialized_message|
            client.socket.send(serialized_message)
          rescue ex : IO::Error
            # TODO: close client that's 'Exception: Closed stream (IO::Error)'
            # puts ex
            # raise ex
            close(client)
          end
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
#   #   client.socket.send(message) if client.character.name != @user.name
#   # end
# end
