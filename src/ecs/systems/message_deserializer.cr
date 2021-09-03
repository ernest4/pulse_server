module Pulse
  module Ecs
    module Systems
      class MessageDeserializer < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # ...
        end

        def update
          remove_message_components
          create_message_components
        end

        def destroy
          # TODO: ...
        end

        MESSAGE_COMPONENT_CLASSES = {
          Pulse::Messages::Move.to_s => Pulse::Ecs::Component::MoveMessage,
        }

        private def remove_message_components
          MESSAGE_COMPONENT_CLASSES.values.each do |message_component_class|
            engine.query(message_component_class) do |query_set|
              message_component = query_set.first
              engine.remove_component(message_component)
            end
          end
        end

        private def create_message_components
          engine.query(MessageEvent) do |query_set|
            message_event = query_set.first
            
            parsed_message = Pulse::Messages::Resolver.resolve(message_event.binary_message)
            # TODO: move out into helper class ? resolver ?
            message_component = MESSAGE_COMPONENT_CLASSES[parsed_message.class.to_s].new(
              entity_id: engine.generate_entity_id,
              from_entity_id: message_event.from_entity_id,
              parsed_message: parsed_message
            )
            engine.add_component(message_component)
          end
        end
      end
    end
  end
end
