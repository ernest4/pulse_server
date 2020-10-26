# TODO: speecs!!!

module Pulse
  module State
    abstract class ApplicationState
      # @maps : Hash(String, Pulse::Map)

      abstract def maps

      # TODO: ... load from files
      abstract def load!
    end
  end
end
