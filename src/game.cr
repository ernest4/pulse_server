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
      @engine.add_system(Pulse::Ecs::Systems::SpatialPartitioning.new)
      @engine.add_system(Pulse::Ecs::Systems::CharacterEnter.new)
      # TODO: any other systems here
      # @engine.add_system(Pulse::Ecs::Systems::Serializer.new) # gonna invoke sidekiq workers
      # @engine.add_system(AI.new)
      @engine.add_system(Pulse::Ecs::Systems::Broadcast.new) # NOTE: always last

      # TODO: try run the server and clean up to connect to client
      # should be close to working now...

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
