module Pulse
  module Ecs
    module Systems
      class MessageListener < Fast::ECS::System
        def initialize
          @messages_buffer = Buffer(Hash(Symbol, Int32 | Slice)).new
        end

        def start
          # ...
        end

        def update
          register_socket_message_listeners
          remove_message_events
          create_message_events
        end

        def destroy
          # TODO: ...
        end

        private def register_socket_message_listeners
          engine.query(ConnectionEvent) do |query_set|
            connection_event = query_set.first

            connection_event.socket.on_binary do |binary_message|
              # TODO: add message throttling mechanism here... ?!?
  
              # TODO: moving this out of here...too its own system
              # parsed_message = Pulse::Messages::Resolver.resolve(binary_message)
              # new_message = Message.new(socket, parsed_message)
              # @message_buffer.push(new_message)

              @messages_buffer.push({
                :from_entity_id => connection_event.id,
                :binary_message => binary_message
              })
            end
          end
        end

        private def remove_message_events
          engine.query(MessageEvent) do |query_set|
            message_event = query_set.first
            engine.remove_component(message_event)
          end
        end

        private def create_message_events
          @messages_buffer.process do |message|
            message_event = Pulse::Ecs::Component::MessageEvent.new(
              entity_id: engine.generate_entity_id,
              from_entity_id: message[:from_entity_id],
              binary_message: message[:binary_message]
            )
            engine.add_component(message_event)
          end
        end
      end
    end
  end
end