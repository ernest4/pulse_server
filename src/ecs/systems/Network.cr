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
          @socket_items_set = SparseSet::SparseSet.new
          @message_buffer = [] of Message
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

        private def handle_connection(socket : HTTP::WebSocket, env)
          # sockets have access to session...
          # puts env.session.int?("hello")
          # puts context.session.strings #returns {}
          # puts context.response.cookies #correctly returns the cookie

          # client = Pulse::Client.new(socket: socket, client_id: env.session.string("uid"))
          # # client = Pulse::Client.new(socket: socket, client_id: Random::Secure.hex) # random id for testing
          # client.initialize_socket(reducer)

          entity_id = create_socket_components(socket, env)
          socket_item = create_socket_item(entity_id, socket)
          register_socket_callbacks(socket_item)
          
          # rescue ex : Pulse::Unauthorized
          #   # TODO: ...
          #   raise ex # just reraise for now...
        end

        private def register_socket_callbacks(socket_item)
          # TODO: may or may not use this, not as efficient as binary, even for regular chat...
          # socket.on_message do |message|
          # end
    
          socket_item.socket.on_binary do |message|
            # reducer.reduce(self, message)

            # TODO: push messages to buffer ?? or create components ??
          end
    
          # TODO: queue async worker to read redis and save player progress to DB?
          # TODO: for now save straight to DB here ???
          # TODO: clean up game state etc.
          socket_item.socket.on_close do |_|
            # reducer.close(self)
            #   # sockets.delete(socket)
            #   puts "Closing Socket: #{socket}"
            remove_socket_item(socket_item)
          end
    
          # reducer.enter(self)
        end

        private def create_socket_components(socket, env)
          entity_id = engine.generate_entity_id
          uuid = env.session.string("uid")
          socket_component = Pulse::Ecs::Component::Socket.new(entity_id: entity_id, uuid: uuid)
          engine.add_component(socket_component)

          serialize_component = Pulse::Ecs::Component::Serialize.new(entity_id: entity_id, action: Serialize::Action::Load)
          engine.add_component(serialize_component)

          entity_id
        end

        private def create_socket_item(entity_id, socket)
          socket_item = Socket.new(entity_id, socket)
          add_socket_item(socket_item)
        end

        private def add_socket_item(socket_item : Socket)
          @socket_items_set.add(socket)
        end

        private def get_socket_item(socket : Pulse::Ecs::Component::Socket)
          # TODO: ...
        end

        private def remove_socket_item(socket_item)
          @socket_items_set.remove(socket_item.id)
        end

        private def dispose_unused_socket_items
          # TODO:
        end

        private def dispose_unused_socket_item(socket : Socket)
          # TODO:
        end
      end
    end
  end
end
