# TODO: speecs!!!

module Pulse
  module State
    abstract class ApplicationState
      abstract def maps : Hash(String, Pulse::Map)

      # TODO: ... load from files
      abstract def load!
    end
  end
end
