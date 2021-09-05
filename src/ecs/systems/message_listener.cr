module Pulse
  module Ecs
    module Systems
      class MessageListener < Fast::ECS::System
        def initialize
          @messages_buffer = Utils::Buffer({from_entity_id: Int32, binary_message: Slice(UInt8)}).new
        end

        def start
          # ...
        end

        def update
          register_socket_message_listeners
          remove_client_message_events
          create_client_message_events
        end

        def destroy
          # TODO: ...
        end

        private def register_socket_message_listeners
          engine.query(Component::ConnectionEvent, Component::Client) do |query_set|
            connection_event, client = Tuple(Component::ConnectionEvent, Component::Client).from(query_set)

            client.socket.on_binary do |binary_message|
              # TODO: add message throttling mechanism here... ?!?
  
              # TODO: moving this out of here...too its own system
              # parsed_message = Pulse::Messages::Resolver.resolve(binary_message)
              # new_message = Message.new(socket, parsed_message)
              # @message_buffer.push(new_message)

              @messages_buffer.push({from_entity_id: client.id, binary_message: binary_message})
            end
          end
        end

        private def remove_client_message_events
          engine.query(Component::ClientMessageEvent) do |query_set|
            client_message_event = query_set.first
            engine.remove_component(client_message_event)
          end
        end

        private def create_client_message_events
          @messages_buffer.process do |message|
            client_message_event =  Component::ClientMessageEvent.new(
              entity_id: engine.generate_entity_id,
              from_entity_id: message[:from_entity_id],
              binary_message: message[:binary_message]
            )
            engine.add_component(client_message_event)
          end
        end
      end
    end
  end
end
