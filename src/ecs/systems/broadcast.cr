module Pulse
  module Ecs
    module Systems
      class Broadcast < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # TODO: ...
        end

        def update
          # naive
          engine.query(Component::ServerMessage) do |query_set|
            server_message = query_set.first.as Component::ServerMessage
            broadcast(server_message)
          end

          # TODO: activate & test more bandwidth efficient option
          # entity_messages_hash = prepare_lists
          # broadcast(entity_messages_hash)
        end

        def destroy
          # TODO: ...
        end

        # naive
        private def broadcast(server_message)
          recipient_client = engine.get_component(Component::Client, server_message.to_entity_id).as Component::Client
          serialized_message = server_message.message.to_slice
          recipient_client.socket.send(serialized_message)
          engine.remove_component(server_message)
        end

        # # TODO: bunch different messages to same client into single message blob, more efficient
        # # than sending messages one by one
        # private def prepare_lists
        #   entity_messages_hash = {} of Int32 => Array(Pulse::Messages::Base)

        #   engine.query(ServerMessage) do |query_set|
        #     server_message = query_set.first

        #     if entity_messages_hash[server_message.to_entity_id].nil?
        #       entity_messages_hash[server_message.to_entity_id] = [server_message.message]
        #     else
        #       entity_messages_hash[server_message.to_entity_id].push(server_message.message)
        #     end

        #     engine.remove_component(server_message)
        #   end

        #   entity_messages_hash
        # end

        # private def broadcast(entity_messages_hash)
        #   entity_messages_hash.each do |entity_id, message_list|
        #     # NOTE: combining lots of small messages into 1 blob should be more efficient
        #     messages_blob = [] of UInt8
             
        #     message_list.map do |message|
        #       messages_blob += message.to_slice#.to_a
        #     end

        #     send(entity_id, messages_blob)
        #   end
        # end

        # private def send(client_entity_id, serialized_message)
        #   recipient_client = engine.get_component(Client, client_entity_id)
        #   recipient_client.socket.send(serialized_message)
        # end
      end
    end
  end
end

# inspiration from: https://davidwalsh.name/3d-websocketshttps://davidwalsh.name/3d-websockets
# NearbyClients component that stores clients in broadcast range. It's an array of entity_ids
# of other client components.
# When broadcasting, iterate over client entity_ids and load them in one by one with # O(n)
# engine.get_component(component_class : Component.class, entity_id : Int32) # O(1)
# ALSO: control the broadcast rate, 2-4 times a second? for movement maybe, shooting should
# be faster
# ALSO: broadcast system will be solely in charge of discarding ServerMessage components !!