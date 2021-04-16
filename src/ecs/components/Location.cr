module Pulse
  module Ecs
    module Component
      class Location < Base
        getter :current_map, :x, :y

        def initialize(entity_id : Int32, current_map : String, x : Int32, y : Int32)
          super(entity_id)
          @current_map = current_map
          @x = x
          @y = y
        end
      end
    end
  end
end
