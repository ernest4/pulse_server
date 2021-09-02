module Pulse
  module Ecs
    module Systems
      class CharacterDeserializer < Fast::ECS::System
        def initialize
          # ...
        end

        def start
          # ...
        end

        def update
          remove_character_deserialization_events
          create_character_deserialization_events
        end

        def destroy
          # TODO: ...
        end

        private def create_character_deserialization_events
          connection_events = [] of ConnectionEvent
          engine.query(ConnectionEvent) { |query_set| connection_events.push(query_set.first) }
          # uids = connection_events.map(&.uid)
          uid_to_entity_id_hash = connection_events.map do |connection_event|
            [connection_event.uid, connection_event.id]
          end.to_h
          # # TODO: move info Fiber(s) maybe ?? ... need to benchmark
          uids = uid_to_entity_id_hash.keys
          user_id_to_uid_hash = ::User.where { _uid.in(uids) }.pluck(:id, :uid).to_h
          user_ids = user_id_to_uid_hash.keys
          characters = ::Character.where { _user_id.in(user_ids) }
          # characters_data = characters.pluck(:name, :current_map, ...) # more efficient ??

          characters.each do |character|
            uid = user_id_to_uid_hash[character.user_id]
            entity_id = uid_to_entity_id_hash[uid]
            character_deserialization_event = Pulse::Ecs::Component::CharacterDeserializationEvent.new(
              entity_id: entity_id,
              character: character
            )
            engine.add_component(character_deserialization_event)
          end
        end

        private def remove_character_deserialization_events
          engine.query(CharacterDeserializationEvent) do |query_set|
            character_deserialization_event = query_set.first
            engine.remove_component(character_deserialization_event)
          end
        end
      end
    end
  end
end
