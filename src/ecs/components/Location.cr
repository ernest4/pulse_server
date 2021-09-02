module Pulse
  module Ecs
    module Component
      class Location < Base
        getter :current_map

        def initialize(entity_id : Int32, current_map : String)
          super(entity_id)
          @current_map = current_map
        end
      end
    end
  end
end
