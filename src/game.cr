module Pulse
  class Game
    def initialize(debug : Bool, server_fps : Int32 = 20)
      @debug = debug
      @server_fps = server_fps
      @server_milliseconds_per_tick = 1000 / @server_fps
      @server_microseconds_per_tick = (1000 * @server_milliseconds_per_tick)
      @engine = Fast::ECS::Engine.new(@debug)

      @game_state = Pulse::State::Memory.new # TODO: dynamically swap between memory and redis based on env config !! (waiting to get config done ...)
      @game_state.load!
    end

    def start
      @engine.add_system(Pulse::Ecs::Systems::Manager.new)
      @engine.add_system(Pulse::Ecs::Systems::ConnectionListener.new)
      @engine.add_system(Pulse::Ecs::Systems::Client.new)
      @engine.add_system(Pulse::Ecs::Systems::MessageListener.new)
      @engine.add_system(Pulse::Ecs::Systems::DisconnectionListener.new)
      @engine.add_system(Pulse::Ecs::Systems::CharacterDeserializer.new)
      @engine.add_system(Pulse::Ecs::Systems::MessageDeserializer.new)
      @engine.add_system(Pulse::Ecs::Systems::MovementControl.new)
      @engine.add_system(Pulse::Ecs::Systems::Movement.new)
      @engine.add_system(Pulse::Ecs::Systems::Collision.new) # TODO: takes in transform and checks it against map. Might be useful to store 'previous' values on Transform (that get auto updated) so in case of collision Transform could be reverted to that?

      # TODO: next need to set up broadcaster / notify everyone of new character joining map
      # set up maps first ?/!

      # Pulse::Ecs::Systems::Broadcast {
      #   update {
      #     query [new_connection, location, transform] {
      #       set up player in the broadcast_hash_list_thing
      #     }

      #     query [move_message, transform] {
      #       update up player in the broadcast_hash_list_thing
      #     }

      #     query [...] {
      #       perform broadcasts using broadcast_hash_list_thing
      #     }
      #   }
      # }

      # ALTERNATIVE: 
      # inspiration from: https://davidwalsh.name/3d-websocketshttps://davidwalsh.name/3d-websockets
      # NearbyClients component that stores clients in broadcast range. It's an array of entity_ids
      # of other client components.
      # When broadcasting, iterate over client entity_ids and load them in one by one with # O(n)
      # engine.get_component(component_class : Component.class, entity_id : Int32) # O(1)
      # ALSO: control the broadcast rate, 2-4 times a second? for movement maybe, shooting should
      # be faster


      # @engine.add_system(Pulse::Ecs::Systems::Deserializer.new) # gonna invoke sidekiq workers
      # @engine.add_system(Pulse::Ecs::Systems::Serializer.new) # gonna invoke sidekiq workers
      # @engine.add_system(Pulse::Ecs::Systems::PlayerEnter.new)
      # @engine.add_system(Input.new)
      # # @engine.add_system(AI.new)
      # @engine.add_system(Pulse::Ecs::Systems::Movement.new(@game_state.maps))
      # @engine.add_system(Collision.new)
      # @engine.add_system(Pulse::Ecs::Systems::Broadcast.new(@game_state.maps))

      tick
    end

    private def tick(last_time = Time.monotonic, total_microseconds = 0)
      spawn do
        current_time = Time.monotonic
        delta_time_micro_seconds = (current_time - last_time).total_microseconds.to_i

        total_microseconds += delta_time_micro_seconds

        if total_microseconds > @server_microseconds_per_tick
          total_milliseconds = total_microseconds // 1000 # get 1 or more full milliseconds
          @engine.update(total_milliseconds)
          # puts "total_microseconds: #{total_microseconds}"
          # puts "total_milliseconds: #{total_milliseconds}"
          total_microseconds = total_microseconds % 1000 # use the remainder for next accumulation
        end

        # VERY IMPORTANT !!!
        Fiber.yield # give Kemal chance to process request(s) (or unix to pass a signal)

        tick(current_time, total_microseconds)
      end
    end
  end
end
