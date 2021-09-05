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
          create_characters_components
        end

        def destroy
          # TODO: ...
        end

        private def create_characters_components
          clients = [] of Component::Client
          engine.query(Component::ConnectionEvent, Component::Client) do |query_set|
            connection_event, client = Tuple(Component::ConnectionEvent, Component::Client).from(query_set)
            clients.push(client)
          end
          # uids = clients.map(&.uid)
          uid_to_entity_id_hash = clients.map { |client| [client.uid, client.id] }.to_h
          # # TODO: move info Fiber(s) maybe ?? ... need to benchmark
          uids = uid_to_entity_id_hash.keys
          user_id_to_uid_hash = ::User.where { _uid.in(uids) }.pluck(:id, :uid).to_h
          user_ids = user_id_to_uid_hash.keys
          characters = ::Character.where { _user_id.in(user_ids) }
          # characters_data = characters.pluck(:name, :current_map, ...) # more efficient ??

          characters.each do |character|
            uid = user_id_to_uid_hash[character.user_id]
            entity_id = uid_to_entity_id_hash[uid].as Int32
            character_components = create_character_components(entity_id, character)
            engine.add_components(character_components)
          end
        end

        private def create_character_components(entity_id, character)
          [
             Component::Character.new(entity_id: entity_id),
             Component::Name.new(entity_id: entity_id, name: character.name),
             Component::Health.new(entity_id: entity_id, points: 100), # TODO: add points to and load points from, the DB
             Component::Location.new(entity_id: entity_id, current_map_name: character.current_map),
             Component::Speed.new(entity_id: entity_id, units: character.speed),
             Component::PhysicsBody.new(entity_id: entity_id),
             Component::Transform.new(
              entity_id: entity_id,
              position_x: character.last_x,
              position_y: character.last_y,
            )
          ]
        end
      end
    end
  end
end
