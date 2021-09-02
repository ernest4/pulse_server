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
      # @engine.add_system(Pulse::Ecs::Systems::Network.new(@debug)) # TODO: basic POC print messages to server console on receipt
      @engine.add_system(Pulse::Ecs::Systems::ConnectionListener.new)
      @engine.add_system(Pulse::Ecs::Systems::Client.new)
      @engine.add_system(Pulse::Ecs::Systems::MessageListener.new)
      @engine.add_system(Pulse::Ecs::Systems::DisconnectionListener.new)
      
      # TODO: next, deserializer / loader, need to use the ConnectionEvent uid to load data from DB !!!!
      # need to decide too create all sub components here or in separate systems using the loaded data blob
      @engine.add_system(Pulse::Ecs::Systems::CharacterDeserializer.new)

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
