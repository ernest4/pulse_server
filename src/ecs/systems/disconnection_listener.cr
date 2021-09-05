module Pulse
  module Ecs
    module Systems
      class DisconnectionListener < Fast::ECS::System
        def initialize
          @disconnections_buffer = Utils::Buffer({entity_id: Int32}).new
        end

        def start
          # ...
        end

        def update
          register_socket_disconnection_listener
          remove_disconnection_events
          create_disconnection_events
        end

        def destroy
          # TODO: ...
        end

        private def register_socket_disconnection_listener
          engine.query(Component::ConnectionEvent, Component::Client) do |query_set|
            connection_event, client = Tuple(Component::ConnectionEvent, Component::Client).from(query_set)

            # TODO: following systems ??
            # TODO: queue async worker to read redis and save player progress to DB?
            # TODO: for now save straight to DB here ???
            # TODO: clean up game state etc.
            client.socket.on_close do |_|
              @disconnections_buffer.push({entity_id: client.id})
            end
          end
        end

        private def remove_disconnection_events
          engine.query(Component::DisconnectionEvent) do |query_set|
            disconnection_event = query_set.first
            engine.remove_component(disconnection_event)
          end
        end

        private def create_disconnection_events
          @disconnections_buffer.process do |disconnection|
            disconnection_event = Component::DisconnectionEvent.new(
              entity_id: disconnection[:entity_id]
            )
            engine.add_component(disconnection_event)
          end
        end
      end
    end
  end
end
