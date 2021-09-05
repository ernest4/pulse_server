module Pulse
  module Ecs
    module Systems
      class ConnectionListener < Fast::ECS::System
        def initialize
          @connections_buffer = Utils::Buffer({socket: HTTP::WebSocket, env: HTTP::Server::Context}).new
        end

        def start
          ws "/" { |socket, env| @connections_buffer.push({socket: socket, env: env}) }
        end

        def update
          remove_connection_events
          create_connection_events
        end

        def destroy
          # TODO: ...
        end

        private def remove_connection_events
          engine.query(Component::ConnectionEvent) do |query_set|
            connection_event = query_set.first
            engine.remove_component(connection_event)
          end
        end

        private def create_connection_events
          @connections_buffer.process do |connection|
            entity_id = engine.generate_entity_id
            connection_event = Component::ConnectionEvent.new(entity_id: entity_id)
            client = Component::Client.new(
              entity_id: entity_id,
              socket: connection[:socket],
              uid: connection[:env].session.string("uid")
            )
            engine.add_components(connection_event, client)
          end
        end
      end
    end
  end
end
