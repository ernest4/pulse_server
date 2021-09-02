module Pulse
  module Ecs
    module Component
      class Transform < Base
        property :position, :rotation, :scale

        def initialize(entity_id : Int32, position_x = 0, position_y = 0, position_z = 0, rotation_x = 0, rotation_y = 0, rotation_z = 0, scale_x = 0, scale_y = 0, scale_z = 0)
          super(entity_id)
          @position = Vector3.new(position_x, position_y, position_z)
          @rotation = Vector3.new(rotation_x, rotation_y, rotation_z)
          @scale = Vector3.new(scale_x, scale_y, scale_z)
        end
      end
    end
  end
end