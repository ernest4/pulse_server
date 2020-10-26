# TODO: speecs!!!

module Pulse
  module State
    abstract class ApplicationState
      # @maps : Hash(String, Pulse::Map)

      # def initialize
      #   # TODO: ...
      #   @maps = {} of String => Pulse::Map
      # end

      # TODO: ... load from files
      abstract def load!
    end
  end
end
