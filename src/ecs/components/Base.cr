module Pulse
  module Ecs
    module Component
      class Base < Fast::ECS::Component
        # TODO: handle serializable vs not serializable

        # property :stringy

        # def initialize(id : Int32, stringy : String)
        #   super(id)
        #   @stringy = stringy
        # end
      end
    end
  end
end