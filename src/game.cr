module Pulse
  class Game
    def initialize
      debug = Pulse::Config::ENVIRONMENT == "development"
      @engine = Fast::ECS::Engine.new(debug)
    end

    def start
      # @engine.add_system(Manager.new)
      # # @engine.add_system(Serializer.new)
      # @engine.add_system(Network.new(debug)) # TODO: basic POC print messages to server console on receipt
      # # @engine.add_system(Input.new)
      # # # @engine.add_system(AI.new)
      # # @engine.add_system(Movement.new)
      # # @engine.add_system(Collision.new)

      tick
    end

    private def tick(last_time = Time.monotonic, total_microseconds = 0)
      spawn do
        current_time = Time.monotonic
        delta_time_micro_seconds = (current_time - last_time).total_microseconds.to_i

        total_microseconds += delta_time_micro_seconds

        if total_microseconds > 1000 # we have at least 1 ms of delta_time accumulated
          total_milliseconds = total_microseconds // 1000 # use 1 or more full milliseconds
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
