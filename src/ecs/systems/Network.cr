module Pulse
  module Ecs
    module Systems
      class Socket < SparseSet::Item # TODO: move this out of here
        getter :socket

        def initialize(entity_id : Int32, socket)
          super
          @socket = socket
        end
      end

      class Network < Fast::ECS::System
        def initialize(debug : Bool)
          @debug = debug
          @socket_set = SparseSet::SparseSet.new
        end

        def start
          # TODO: ...

          # TODO: need to implement automatic Ping of client sockets to check if alive and clean them up out
          # of memory if the connection dead...

          ws "/" do |socket, env|
            handle_connection(socket, env)
          end
        end

        def update
          # TODO: ...
        end

        def destroy
          # TODO: ...
        end

        private def handle_connection(socket, env)
          # sockets have access to session...
          # puts env.session.int?("hello")
          # puts context.session.strings #returns {}
          # puts context.response.cookies #correctly returns the cookie
        
          # client = Pulse::Client.new(socket: socket, client_id: env.session.string("uid"))
          # # client = Pulse::Client.new(socket: socket, client_id: Random::Secure.hex) # random id for testing
          # client.initialize_socket(reducer)

          entity_id = engine.generate_entity_id
          socket_component = Pulse::Ecs::Component::Socket.new(entity_id)
          engine.add_component(socket_component)

          socket_item = Socket.new(entity_id, socket)
          add_socket_item(socket_item)
          
          
          # rescue ex : Pulse::Unauthorized
          #   # TODO: ...
          #   raise ex # just reraise for now...
        end

        private def add_socket_item(socket)
          # TODO: ...
        end

        private def get_socket_item(socket)
          # TODO: ...
        end

        private def dispose_unused_socket_items(sockets)
          # TODO:
        end

        private def dispose_unused_socket_item(socket)
          # TODO:
        end
      end
    end
  end
end
