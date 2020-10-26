# TODO: specs !!!

# TESTING (not really open struct... sign... hard to implement in crystal)
class OpenStruct
  def name
    "Ernest"
  end
end

# TODO: probably have User::Memory and User::Redis
module Pulse
  class User
    @name : String
    @current_map : String

    property :name, :current_map

    def initialize(client_id)
      @client_id = client_id
      load!
    end

    def load!
      # TODO: load from DB
      # user = User.query.find({client_id: @client_id})

      # TESTING:
      @user = OpenStruct.new
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