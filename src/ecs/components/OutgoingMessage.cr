module Pulse
  module Ecs
    module Component
      class OutgoingMessage < Base
        getter :source, :destination

        def initialize(entity_id : Int32, source : String, destination : String)
          super(entity_id)
          @source = source
          @destination = destination
        end
      end
    end
  end
end
