module Pulse
  module Ecs
    module Component
      class Name < Fast::ECS::Component
        getter :name

        def initialize(entity_id : Int32, name : String)
          super(entity_id)
          @name = name
        end
      end
    end
  end
end
