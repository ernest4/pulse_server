module Pulse
  module Ecs
    module Component
      class NearbyCharacters < Base
        property :entity_ids_set

        def initialize(entity_id : Int32)
          super(entity_id)
          @entity_ids_set = SparseSet::SparseSet.new
        end
      end
    end
  end
end
