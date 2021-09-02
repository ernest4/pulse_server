module Pulse
  module Ecs
    module Component
      class Speed < Base
        getter :units

        def initialize(entity_id : Int32, units : Int32)
          super(entity_id)
          @units = units
        end
      end
    end
  end
end
