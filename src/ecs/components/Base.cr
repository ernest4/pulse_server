module Pulse
  module Ecs
    module Component
      class Base < Fast::ECS::Component
        @@serializable_fields = [] of Symbol
        # TODO: handle serializable vs not serializable

        # property :stringy

        # def initialize(id : Int32, stringy : String)
        #   super(id)
        #   @stringy = stringy
        # end

        def self.serialize(*fields : Symbol)
          fields.each { |field| @@serializable_fields.push(field) }
        end

        def self.serializable_fields
          @@serializable_fields
        end
      end
    end
  end
end