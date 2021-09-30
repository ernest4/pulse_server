module Pulse
  module Ecs
    module Utils
      class Vector3
        property x : Float32
        property y : Float32
        property z : Float32

        def initialize(x = 0, y = 0, z = 0)
          @x = x
          @y = y
          @z = z
        end
      end
    end
  end
end
