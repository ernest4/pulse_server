# TODO: speeecs ?!?!?
module Pulse
  class Map
    class Cell
      def initialize
        @characters = SparseSet::SparseSet.new
      end

      def add_character(entity_id)
        @characters.add(SparseSet::Item.new(entity_id))
      end

      def remove_character(entity_id)
        @characters.remove(entity_id)
      end

      def stream_ids
        @characters.stream do |sparse_set_item|
          yield sparse_set_item.id
        end
      end
    end

    TILE_SIZE_IN_PX = 32_u8 # 32 px
    MAX_WORLD_SIZE_IN_TILES = 60_u16
    MAX_WORLD_SIZE_IN_PX = (TILE_SIZE_IN_PX * MAX_WORLD_SIZE_IN_TILES).to_u16 # square worlds
    CELL_SIZE_IN_PX = TILE_SIZE_IN_PX * 60
    MAX_WORLD_SIZE_IN_CELLS = MAX_WORLD_SIZE_IN_PX / CELL_SIZE_IN_PX

    property :name, :cell, :tiles, :width, :height

    @tiles : Array(Array(UInt16))
    @width : UInt16
    @height : UInt16
    # @clients : Array(Pulse::Client)

    # def initialize(width, height, seed = 1234)
    #   @width = width
    #   @height = height

    #   seeded_number_generator = Random.new(seed) # side effect, extract as input to function

    #   tiles_u32 = generate_tiles(seeded_number_generator, width, height)
    #   @tiles = map_i32_to_u16(tiles_u32)
    #   @name = generate_name(seeded_number_generator)
    #   @clients = [] of Pulse::Client
    # end

    # def initialize(file_path : (String)?)
    #   # TODO: parse file to extract name and tiles...
    #   @file_path = file_path

    #   # placeholder
    #   @tiles = map_i32_to_u16([[1,1], [1,1]])
    #   @width = 2
    #   @height = 2
    #   @name = "file_loaded_map"
    #   @clients = [] of Pulse::Client
    # end

    # For testing
    def initialize
      tiles_u32 = [[1,1,1,1,1,1],
                  [1,2,1,1,2,1],
                  [1,1,4,4,1,1],
                  [1,2,1,4,3,1],
                  [1,1,1,1,1,1],
                  [1,1,1,1,1,1]]

      @tiles = map_i32_to_u16(tiles_u32)
      @name = "hub_0" # TODO: default for any new character
      @width = 6
      @height = 6
    end

    def map_i32_to_u16(map_i32)
      map_i32.map do |row|
        row.map do |column|
          column.to_u16
        end
      end
    end

    def cell_size
      CELL_SIZE_IN_PX
    end

    def world_to_cell_coordinates(x, y)
      # x = x // cell_size;
      # y = y // cell_size;
     
      # {x: x, y: y}

      [x // cell_size, y // cell_size]
    end

    # map needs to know which cell character should be in.
    # add to cell if in no cells. OR
    # remove from old cell and put into new cell.
    def update_map(x, y, entity_id)
      # TODO: check current cell vs new cell and update accordingly
      add_character(transform.position.x, transform.position.y, connection_event.id)
    end
    
    def cell(x, y)
      # TODO: ...
    end
    
    private def add_character(x, y, entity_id)
      cell_x, cell_y = world_to_cell_coordinates(x, y)
      cell(cell_x, cell_y).add_character(entity_id)
    end

    private def remove_character(x, y, entity_id)
      cell_x, cell_y = world_to_cell_coordinates(x, y)
      cell(cell_x, cell_y).remove_character(entity_id)
    end

    # def load
    #   # TODO: ...
    # end

    # def generate_tiles(number_generator, width, height)
    #   (0..height).map do |row|
    #     (0..width).map do |column|
    #       generate_tile(number_generator)
    #     end
    #   end
    # end

    # def generate_tile(number_generator)
    #   number_generator.rand(1..5)
    # end

    # def generate_name(seeded_number_generator)
    #   # TODO: will involve keeping track of the current highest name value, then taking that and
    #   # producing the next incremental one... like C5 -> C6 ... D1 -> D2 ...
    #   "Genesis_#{seeded_number_generator.rand(1..5)}"
    # end
  end
end