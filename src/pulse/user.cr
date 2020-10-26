# TODO: specs !!!

# TESTING (not really open struct... sign... hard to implement in crystal)
class OpenStruct
  property :id, :name, :last_x, :last_y

  def initialize
    @id = 123
    @name = "Ernestό"
    @last_x = 3_u16
    @last_y = 2_u16
  end
end

# TODO: probably have User::Memory and User::Redis
module Pulse
  class User
    @id : Int32
    @client_id : String
    @name : String
    @current_map : (String)?
    @last_x : UInt16
    @last_y : UInt16

    property :id, :name, :current_map, :last_x, :last_y

    def initialize(client_id)
      @id = -1
      @client_id = client_id

      @name = ""
      # @current_map = ""
      @last_x = 0
      @last_y = 0

      load!
    end

    def load!
      # TODO: load from DB
      # user = User.query.find({client_id: @client_id})

      # TESTING:
      user = OpenStruct.new

      @id = user.id
      @name = user.name
      @last_x = user.last_x
      @last_y = user.last_y
    end

    # TODO: wip ....
    # def update({})
    # end
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