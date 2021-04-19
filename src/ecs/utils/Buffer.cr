module Pulse
  module Ecs
    module Utils
      class Buffer(T)
        include Enumerable(T)

        def initialize
          @buffer1 = [] of T
          @buffer2 = [] of T
          @active_buffer = @buffer1
          @secondary_buffer = @buffer2
        end

        def push(item : T)
          @active_buffer.push(item)
        end

        def swap
          temp = @active_buffer
          @active_buffer = @secondary_buffer
          @secondary_buffer = temp
        end

        def flush
          @secondary_buffer.clear
        end

        def flush_all
          @active_buffer.clear
          @secondary_buffer.clear
        end

        def each
          @secondary_buffer.each { |item| yield item }
        end
      end
    end
  end
end
