module Pulse
  module Ecs
    module Component
      class Location < Fast::ECS::Component
        getter :current_map_name

        def initialize(entity_id : Int32, current_map_name : String)
          super(entity_id)
          @current_map_name = current_map_name
        end
      end
    end
  end
end
