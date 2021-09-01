module Pulse
  module Ecs
    module Systems
      class Client < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # ...
        end

        def update
          create_socket_components
        end

        def destroy
          # TODO: ...
        end

        private def create_socket_components
          engine.query(ConnectionEvent) do |query_set|
            connection_event = query_set.first

            register_socket_callbacks(connection_event.socket)

            socket = Pulse::Ecs::Component::Client.new(
              entity_id: connection_event.id,
              socket: connection_event.socket,
            )
            engine.add_component(socket)
          end
        end
      end
    end
  end
end
