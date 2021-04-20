module Pulse
  module Ecs
    module Component
      class Transform < Base
        property :x, :y
        # serialize :uuid # <- this comes from Pulse::Ecs::Component::Base

        def initialize(entity_id : Int32, x : Int32, y : Int32)
          super(entity_id)
          @x = x
          @y = y
        end
      end
    end
  end
end