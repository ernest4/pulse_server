# TODO: speeecs ?!?!?
module Pulse
  class Map
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
      # TODO: ...
      # 1. read direction
      # 2. check map tiles if can move there
      # 3. return new position (which might be same as old position if can't move...)

      speed = client.user.speed
      last_x = client.user.last_x
      last_y = client.user.last_y

      case direction
      when Pulse::Messages::Move::LEFT
        {:x => last_x - speed, :y => last_y}
      when Pulse::Messages::Move::LEFT_TOP
        {:x => last_x - speed, :y => last_y - speed}
      when Pulse::Messages::Move::TOP
        {:x => last_x, :y => last_y - speed}
      when Pulse::Messages::Move::RIGHT_TOP
        {:x => last_x + speed, :y => last_y - speed}
      when Pulse::Messages::Move::RIGHT
        {:x => last_x + speed, :y => last_y}
      when Pulse::Messages::Move::RIGHT_BOTTOM
        {:x => last_x + speed, :y => last_y + speed}
      when Pulse::Messages::Move::BOTTOM
        {:x => last_x, :y => last_y + speed}
      when Pulse::Messages::Move::LEFT_BOTTOM
        {:x => last_x - speed, :y => last_y + speed}
      else
        puts "[Pulse] Unrecognized move direction #{parsed_message.direction}"
      end

      last_position = {:x => last_x, :y => last_y}
      can_move_to?(new_position) ? new_position : last_position
    end

    private def can_move_to?(position)
      # TODO: this will need to be bit more specific on which tile does (x,y) sit on
      tile = @tiles[position[:y]][position[:x]]

      # TODO: use proper tile type numbers later...
      tile == 0 || tile == 1 || tile == 2 || tile == 3 || tile == 4
    end
  end
end