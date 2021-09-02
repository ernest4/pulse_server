module Pulse
  module Ecs
    module Systems
      class ConnectionListener < Fast::ECS::System
        def initialize
          @connections_buffer = Buffer(Hash(Symbol, HTTP::WebSocket | Hash)).new
        end

        def start
          ws "/" do |socket, env|
            @connections_buffer.push({:socket => socket, :env => env})
          end
        end

        def update
          remove_connection_events
          create_connection_events
        end

        def destroy
          # TODO: ...
        end

        private def remove_connection_events
          engine.query(ConnectionEvent) do |query_set|
            connection_event = query_set.first
            engine.remove_component(connection_event)
          end
        end

        private def create_connection_events
          @connections_buffer.process do |connection|
            connection_event = Pulse::Ecs::Component::ConnectionEvent.new(
              entity_id: engine.generate_entity_id,
              socket: connection[:socket],
              uid: connection[:env].session.string("uid")
            )
            engine.add_component(connection_event)
          end
        end
      end
    end
  end
end
