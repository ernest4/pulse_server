module Pulse
  module Ecs
    module Systems
      class SpatialPartitioning < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # TODO: ...
        end

        def update
          # naive
          engine.query(...) do |query_set|
            # https://davidwalsh.name/3d-websockets
          end
        end

        def destroy
          # TODO: ...
        end
      end
    end
  end
end
