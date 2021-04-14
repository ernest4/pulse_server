module Pulse
  module Ecs
    module Systems
      class Network < Fast::ECS::System
        def initialize(debug : Bool)
          @debug = debug
        end

        def start
          # TODO: ...

          # TODO: need to implement automatic Ping of client sockets to check if alive and clean them up out
          # of memory if the connection dead...

          # TODO: push thus into system
          ws "/" do |socket, env|
            #   # sockets have access to session...
            #   # puts env.session.int?("hello")
            #   # puts context.session.strings #returns {}
            #   # puts context.response.cookies #correctly returns the cookie
            
            #   # TODO: read from session
            #   client = Pulse::Client.new(socket: socket, client_id: env.session.string("uid"))
            #   # client = Pulse::Client.new(socket: socket, client_id: Random::Secure.hex) # random id for testing
            #   # client.authenticate!
            #   client.initialize_socket(reducer)
            #   # client.enter_map
            
            
            # # rescue ex : Pulse::Unauthorized
            # #   # TODO: ...
            # #   raise ex # just reraise for now...
          end
        end

        def update
          # TODO: ...
        end

        def destroy
          # TODO: ...
        end
      end
    end
  end
end
