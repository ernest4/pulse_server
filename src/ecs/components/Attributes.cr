module Pulse
  module Ecs
    module Component
      class Attributes < Base
        getter :speed, :name

        def initialize(entity_id : Int32, speed : String, name : String)
          super(entity_id)
          @speed = speed
          @name = name
        end
      end
    end
  end
end
