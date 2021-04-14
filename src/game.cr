module Pulse
  class Game
    def initialize()
      # TODO: ...
    end

    def start
      debug = Pulse::Config::ENVIRONMENT == "development"
      # init engine and systems
      engine = Fast::ECS::Engine.new(debug)
      engine.add_system(Manager.new)
      # engine.add_system(Serializer.new)
      engine.add_system(Network.new(debug)) # TODO: basic POC print messages to server console on receipt
      # engine.add_system(Input.new)
      # # engine.add_system(AI.new)
      # engine.add_system(Movement.new)
      # engine.add_system(Collision.new)

      # last_time = Time::Span.new # Time::Span.new => time since epoch...
      last_time = Time.monotonic # => Time::Span
      spawn do
        current_time = Time.monotonic
        delta_time = (current_time - last_time).total_milliseconds.to_i

        engine.update(delta_time)

        last_time = current_time

        # yield to Kemal to process socket messages etc. or it will come back immediately to process
        # another engine update
        Fiber.yield
      end
      # create fiber, do engine tick and yield, over and over
    end
  end
end
