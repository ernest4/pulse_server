module Pulse
  module Ecs
    module Systems
      class Collision < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # TODO: ...
        end

        def update
          engine.query(Transform) { |query_set| handle_collision(query_set) }
        end

        def destroy
          # TODO: ...
        end

        private def handle_collision(query_set)
          transform = query_set.first

          # TODO: ...
          # TODO: takes in transform and checks it against map. Might be useful to store 'previous' values on Transform (that get auto updated) so in case of collision Transform could be reverted to that?# TODO: takes in transform and checks it against map. Might be useful to store 'previous' values on Transform (that get auto updated) so in case of collision Transform could be reverted to that?
        end
      end
    end
  end
end
