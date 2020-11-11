# TODO: specs !!!

# TESTING (not really open struct... sign... hard to implement in crystal)
# class OpenStruct
#   property :id, :name, :last_x, :last_y, :speed

#   def initialize
#     @id = 123
#     @name = "Ernestό"
#     @last_x = 3
#     @last_y = 2
#     @speed = 32
#   end
# end

# TODO: probably have User::Memory and User::Redis
module Pulse
  class Character
    # TODO: the default values here should come from the model somehow...
    # @id : Int32 = -1
    # # # @client_id : String
    # @name : String = ""
    # @current_map : (String)?
    # @last_x : Int32 = 0
    # @last_y : Int32 = 0
    # @speed : Int32 = 32 # 32 pixels per second
    @character : ::Character

    # property :id, :name, :current_map, :last_x, :last_y, :speed

    delegate id, name, current_map, last_x, last_y, speed, to: @character # delegates known methods

    # def initialize(client_id : String)
    #   # @id = -1
    #   @client_id = client_id

    #   # @name = ""
    #   # @current_map = ""
    #   # @last_x = 0
    #   # @last_y = 0

    #   load!
    # end

    def initialize(character_id : Int32)
      @character = ::Character.find!(character_id)
      # load!(id)
    rescue ex : Jennifer::RecordNotFound
      # TODO: ...
      raise ex # just reraise for now...
    end

    # def load!(id)
    #   # TESTING:
    #   # user = OpenStruct.new

    #   # @id = user.id
    #   # @name = user.name
    #   # @last_x = user.last_x
    #   # @last_y = user.last_y
    #   # @speed = user.speed

    #   # TODO: load from DB
    #   @character = ::Character.find(id)
    # end

    def position
      {:x => last_x, :y => last_y}
    end

    def position=(new_position)
      last_x = new_position[:x]
      last_y = new_position[:y]
    end

    # TODO: wip ....
    # def update({})
    # end
    # OR
    def save!
      # TODO: serialize local values and save to Redis / DB / w.e.
      @character.save! # TODO: error handling !?!?!
    end
  end
end

# DELEGATE example...

# class StringWrapper
#   def initialize(@string : String)
#   end

#   delegate downcase, to: @string
#   delegate gsub, to: @string
#   delegate empty?, capitalize, to: @string
# end




# macro define_dummy_methods(hash)
#   {% for key, value in hash %}
#     def {{key.id}}
#       {{value}}
#     end
#   {% end %}
# end

# define_dummy_methods({foo: 10, bar: 20})
# foo # => 10
# bar # => 20