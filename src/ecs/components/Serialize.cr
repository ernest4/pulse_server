module Pulse
  module Ecs
    module Component
      class Serialize < Base
        enum Action
          Load
          Save
        end

        getter :action, :components

        def initialize(entity_id : Int32, action : Action, components : Symbol | Array(Symbol) | Nil)
          super(entity_id)
          @action = action
          @components = components # if nil, load all components...
        end
      end
    end
  end
end
