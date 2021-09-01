module Pulse
  module Ecs
    module Component
      class Base < Fast::ECS::Component
        # property :stringy

        # def initialize(id : Int32, stringy : String)
        #   super(id)
        #   @stringy = stringy
        # end

        def self.serialize(*fields : Symbol)
          # TODO: macro yes ??
        end

        def self.serializable_fields
          # @@serializable_fields
        end
      end
    end
  end
end