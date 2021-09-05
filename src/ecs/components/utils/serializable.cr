module Pulse
  module Ecs
    module Component
      module Utils
        module Serializable
          def serialize(*fields : Symbol)
            # TODO: macro yes ??
          end
  
          def serializable_fields
            # @@serializable_fields
          end
        end
      end
    end
  end
end

# TODO: figure this out later