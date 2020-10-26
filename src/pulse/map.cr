# TODO: speeecs ?!?!?
module Pulse
  class Map
    property :name, :clients

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
      number_generator.rand(1..10)
    end

    def generate_name(seeded_number_generator)
      # TODO: will involve keeping track of the current highest name value, then taking that and
      # producing the next incremental one... like C5 -> C6 ... D1 -> D2 ...
      "Genesis_#{seeded_number_generator.rand(1..10)}"
    end
  end
end