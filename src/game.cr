module Pulse
  class Game
    @server_milliseconds_per_tick : Int32
    @server_microseconds_per_tick : Int32

    def initialize(debug : Bool, server_max_fps : Int32 = 20)
      @debug = debug
      @server_max_fps = server_max_fps
      @server_milliseconds_per_tick = 1000 // @server_max_fps
      @server_microseconds_per_tick = (1000 * @server_milliseconds_per_tick)
      @engine = Fast::ECS::Engine.new(@debug)

      @state = Pulse::State::Memory.new
      @state.load!
    end

    def start
      @engine.add_system(Pulse::Ecs::Systems::Manager.new)
      @engine.add_system(Pulse::Ecs::Systems::ConnectionListener.new)
      @engine.add_system(Pulse::Ecs::Systems::MessageListener.new)
      @engine.add_system(Pulse::Ecs::Systems::MessageDeserializer.new)
      @engine.add_system(Pulse::Ecs::Systems::DisconnectionListener.new)
      @engine.add_system(Pulse::Ecs::Systems::CharacterDeserializer.new)
      @engine.add_system(Pulse::Ecs::Systems::MovementControl.new)
      @engine.add_system(Pulse::Ecs::Systems::Movement.new)
      @engine.add_system(Pulse::Ecs::Systems::Collision.new) # TODO: takes in transform and checks it against map. Might be useful to store 'previous' values on Transform (that get auto updated) so in case of collision Transform could be reverted to that?
      @engine.add_system(Pulse::Ecs::Systems::SpatialPartitioning.new(@state))
      @engine.add_system(Pulse::Ecs::Systems::CharacterEnter.new(@state))
      @engine.add_system(Pulse::Ecs::Systems::CharacterMove.new)
      # TODO: any other systems here
      # @engine.add_system(Pulse::Ecs::Systems::Serializer.new) # gonna invoke sidekiq workers
      # @engine.add_system(AI.new)
      @engine.add_system(Pulse::Ecs::Systems::Broadcast.new) # NOTE: always last

      tick
    end

    private def tick
      last_time = Time.monotonic
      total_microseconds = 0

      spawn do
        loop do
          current_time = Time.monotonic
          delta_time_micro_seconds = (current_time - last_time).total_microseconds
          last_time = current_time

          total_microseconds += delta_time_micro_seconds
  
          if total_microseconds > @server_microseconds_per_tick
            total_milliseconds = (total_microseconds // 1000).to_i # get 1 or more full milliseconds
            @engine.update(total_milliseconds)
            # puts "total_microseconds: #{total_microseconds}"
            # puts "total_milliseconds: #{total_milliseconds}"
            # use the remainder for next accumulation
            total_microseconds = total_microseconds % @server_microseconds_per_tick
          end
  
          # VERY IMPORTANT !!!
          Fiber.yield # give Kemal chance to process request(s) (or unix to pass a signal)
        end
      end
    end
  end
end
