module Pulse
  module Ecs
    module Component
      class Health < Base
        getter :points

        def initialize(entity_id : Int32, points : Int32)
          super(entity_id)
          @points = points
        end
      end
    end
  end
end
