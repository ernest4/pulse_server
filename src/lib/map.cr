# TODO: speeecs ?!?!?
module Pulse
  class Map
    TILE_SIZE = 32 # 32 px
    MAX_WORLD_SIZE = TILE_SIZE * 60

    property :name, :clients, :tiles

    @tiles : Array(Array(Int32))
    # @clients : Array(Pulse::Client)

    def initialize(width, height, seed = 1234)
      seeded_number_generator = Random.new(seed)

      @tiles = generate_tiles(seeded_number_generator, width, height)
      @name = generate_name(seeded_number_generator)
      @clients = [] of Pulse::Client
    end

    def initialize(file_path : (String)?)
      # TODO: parse file to extract name and tiles...
      @file_path = file_path

      # placeholder
      @tiles = [[1,1], [1,1]]
      @name = "file_loaded_map"
      @clients = [] of Pulse::Client
    end

    # def load
    #   # TODO: ...
    # end

    def generate_tiles(number_generator, width, height)
      (0..height).map do |row|
        (0..width).map do |column|
          generate_tile(number_generator)
        end
      end
    end

    def generate_tile(number_generator)
      number_generator.rand(1..5)
    end

    def generate_name(seeded_number_generator)
      # TODO: will involve keeping track of the current highest name value, then taking that and
      # producing the next incremental one... like C5 -> C6 ... D1 -> D2 ...
      "Genesis_#{seeded_number_generator.rand(1..5)}"
    end

    def move(client, direction)
      speed = client.character.speed
      last_x = client.character.last_x
      last_y = client.character.last_y

      new_position = {:x => last_x, :y => last_y}

      case direction
      when Pulse::Messages::Move::LEFT
        new_position = {:x => last_x - speed, :y => last_y}
      when Pulse::Messages::Move::LEFT_TOP
        new_position = {:x => last_x - speed, :y => last_y - speed}
      when Pulse::Messages::Move::TOP
        new_position = {:x => last_x, :y => last_y - speed}
      when Pulse::Messages::Move::RIGHT_TOP
        new_position = {:x => last_x + speed, :y => last_y - speed}
      when Pulse::Messages::Move::RIGHT
        new_position = {:x => last_x + speed, :y => last_y}
      when Pulse::Messages::Move::RIGHT_BOTTOM
        new_position = {:x => last_x + speed, :y => last_y + speed}
      when Pulse::Messages::Move::BOTTOM
        new_position = {:x => last_x, :y => last_y + speed}
      when Pulse::Messages::Move::LEFT_BOTTOM
        new_position = {:x => last_x - speed, :y => last_y + speed}
      else
        puts "[Pulse] Unrecognized move direction #{direction}"
      end

      new_position = clip_position_to_world_bounds(new_position)

      last_position = {:x => last_x, :y => last_y}
      can_move_to?(new_position) ? new_position : last_position
    end

    private def clip_position_to_world_bounds(position)
      {:x => position[:x].clamp(0, MAX_WORLD_SIZE), :y => position[:y].clamp(0, MAX_WORLD_SIZE)}
    end

    private def can_move_to?(position)
      tile_y = position[:y] // TILE_SIZE
      tile_x = position[:x] // TILE_SIZE

      tile = @tiles[tile_y][tile_x]

      # TODO: use proper tile type numbers later...
      # tile == 0 || tile == 1 || tile == 2 || tile == 3 || tile == 4
      tile != 5
    end
  end
end