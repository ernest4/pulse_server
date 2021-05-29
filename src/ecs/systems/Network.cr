module Pulse
  module Ecs
    module Systems
      class Message
        getter :socket_item, :parsed_message

        def initialize(socket_item : Socket, parsed_message : Pulse::Messages::ApplicationMessage)
          @socket_item = socket_item
          @parsed_message = parsed_message
        end
      end

      class Socket < SparseSet::Item # TODO: move this out of here
        property :last_received_time
        getter :socket

        def initialize(entity_id : Int32, socket)
          super
          @socket = socket
          @last_received_time = {} of UInt8 => Time::Span
        end
      end

      class Network < Fast::ECS::System
        def initialize(debug : Bool)
          @debug = debug
          @socket_items_set = SparseSet::SparseSet.new
          @message_buffer = Buffer(Message).new
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
          # clean_up_message_event_entities
          # create_message_event_entities
          create_message_components
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

          entity_id = create_socket_component(socket, env)
          socket_item = create_socket_item(entity_id, socket)
          register_socket_callbacks(socket_item)

          # TODO: all of the below should happen in their own systems!

          # serialize_component = Pulse::Ecs::Component::Serialize.new(entity_id: entity_id, action: Serialize::Action::Load)
          # engine.add_component(serialize_component)

          # # TODO: some "welcome" system will init this enter() step ??
          # # reducer.enter(self)
          # # TODO: rename => Pulse::Ecs::Component::Event::Player::Enter
          # player_enter_event = Pulse::Ecs::Component::PlayerEnterEvent.new(entity_id)
          # engine.add_component(player_enter_event)
          
          # rescue ex : Pulse::Unauthorized
          #   # TODO: ...
          #   raise ex # just reraise for now...
        end

        private def register_socket_callbacks(socket_item)
          # TODO: may or may not use this, not as efficient as binary, even for regular chat...
          # socket.on_message do |message|
          # end
    
          socket_item.socket.on_binary do |binary_message|
            # reducer.reduce(self, message)
            
            # TODO: add message throttling mechanism here...

            parsed_message = Pulse::Messages::Resolver.resolve(binary_message)
            new_message = Message.new(socket_item, parsed_message)
            @message_buffer.push(new_message)
          end
    
          # TODO: queue async worker to read redis and save player progress to DB?
          # TODO: for now save straight to DB here ???
          # TODO: clean up game state etc.
          socket_item.socket.on_close do |_|
            # reducer.close(self)
            #   # sockets.delete(socket)
            #   puts "Closing Socket: #{socket}"
            remove_socket_item(socket_item)
            player_exit_event = Pulse::Ecs::Component::PlayerExitEvent.new(socket_item.id)
            engine.add_component(player_exit_event)
          end
        end

        private def create_socket_component(socket, env)
          entity_id = engine.generate_entity_id
          uuid = env.session.string("uid")
          socket_component = Pulse::Ecs::Component::Client::Socket.new(entity_id: entity_id, uuid: uuid)
          engine.add_component(socket_component)
          entity_id
        end

        private def create_socket_item(entity_id, socket)
          socket_item = Socket.new(entity_id, socket)
          add_socket_item(socket_item)
          socket_item
        end

        private def add_socket_item(socket_item : Socket)
          @socket_items_set.add(socket_item)
        end

        private def get_socket_item(socket : Pulse::Ecs::Component::Client::Socket)
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

        # private def clean_up_message_event_entities
        #   engine.query(MessageEvent) do |query_set|
        #     message_event = query_set.first
        #     engine.remove_entity(message_event.id)
        #   end
        # end

        # private def create_message_event_entities
        #   @message_buffer.swap

        #   @message_buffer.each do |message|
        #     entity_id = engine.generate_entity_id
        #     binary_message = message.binary_message
        #     socket_entity_id = message.socket_item.id
        #     message_event_component = Pulse::Ecs::Component::MessageEvent.new(entity_id: entity_id, category: MessageEvent::Category::Binary, message: binary_message, from: socket_entity_id)
        #     engine.add_component(message_event_component)
        #   end

        #   @message_buffer.flush
        # end

        private def create_message_components
          # TODO: ... create a message component per type of message...
          # e.g Client::Message::Move

          @message_buffer.swap

          @message_buffer.each do |message|
            parsed_message = message.parsed_message
            socket_entity_id = message.socket_item.id
            # NOTE: this will automatically enforce one message type per engine tick i think !!
            # which means it automatically throttles the messages ? that would be good ...
            # but then the other messages will be silently dropped...which is not good
            message_component = Pulse::Ecs::Component::Client::Message::Move.new(entity_id: socket_entity_id, message: parsed_message)
            engine.add_component(message_component)
          end

          @message_buffer.flush
        end
      end
    end
  end
end
