module Pulse
  module Ecs
    module Systems
      class CharacterLoader < Fast::ECS::System
        def initialize
          # @disconnections_buffer = Buffer(Hash(Symbol, Int32)).new
        end

        def start
          # ...
        end

        def update
          load_character_data
          # remove_disconnection_events
          # create_disconnection_events
        end

        def destroy
          # TODO: ...
        end

        private def load_character_data
          # @user = ::User.where { _uid == client_id }.first!
          # @character = ::Character.find!(@user.characters.first.id!)

          # TODO: use the cli to see if you can perform batch queries like
          # ... buffer uuids from connection events then:
          # user_ids = ::User.where { _uid.in(uuids) }.pluck(:id)
          # characters = ::Character.where { _user_id.in(user_ids) }
          # characters_data = characters.pluck(:name, :current_map, ...)

          engine.query(ConnectionEvent) do |query_set|
            connection_event = query_set.first

            # TODO: move info Fiber(s) ?? batch query with pluck() for values ??
            user = ::User.where { _uid == connection_event.uuid }.first
            return do_something if user.nil?

            character = ::Character.find(user.characters.first.id)
            return do_something_else if character.nil?

            # TODO: read data to create component(s) ?
          end
        end

        # private def remove_disconnection_events
        #   engine.query(DisconnectionEvent) do |query_set|
        #     disconnection_event = query_set.first
        #     engine.remove_component(disconnection_event)
        #   end
        # end

        # private def create_disconnection_events
        #   @disconnections_buffer.process do |disconnection|
        #     disconnection_event = Pulse::Ecs::Component::DisconnectionEvent.new(
        #       entity_id: disconnection[:entity_id]
        #     )
        #     engine.add_component(disconnection_event)
        #   end
        # end
      end
    end
  end
end
