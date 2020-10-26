# TODO: specs !!!

module Pulse
  module Messages
    # abstract class ApplicationMessage
    class ApplicationMessage
      class IOMemoryWrapper
        def initialize
          @io_memory = IO::Memory.new
        end

        def set_byte(value)
          set_bytes(value)
        end

        def set_number(value)
          set_bytes(value)
        end

        def set_bytes(value)
          @io_memory.write_bytes(value, IO::ByteFormat::LittleEndian)
        end

        def set_string(string : String)
          @io_memory.write_utf8(string.to_slice)
        end
      end

      # def initialize(message : Slice(UInt8))
      #   @message = message
      # end

      # def parse
      #   MESSAGE_TYPE_CLASSES[class_type].new.parse(@message)
      # end

      # def class_type
      #   get_byte
      # end

      def get_byte
        io_memory_message.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      end

      def get_number
        io_memory_message.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      end

      def get_string
        # TODO: ...
        # buffer = uninitialized UInt8[1024]
        # bytes_read = io2.read_utf8(buffer.to_slice)
        # slice = buffer.to_slice[0, bytes_read]
        # puts slice
        # stringy2 = String.new(slice)
      end

      def io_memory_message
        @io_memory_message ||= IO::Memory.new(@message)
      end

      def to_slice
        new_io_memory_message = IOMemoryWrapper.new
        yield new_io_memory_message
        new_io_memory_message.to_slice
      end
    end
  end
end

# ----------------------- this encoding works with any string...
# FORMAT = IO::ByteFormat::LittleEndian
# # encoding

# typ = 1_u8   # 1 byte
# categ = 4_u16 # 2 bytes
# stringy = "hiΓεια σ123ου κόσμε你".to_slice
# stringy.size

# # io = IO::Memory.new(10)  # Specifying the capacity is optional
# io = IO::Memory.new

# io.write_bytes(typ, FORMAT) # Specifying the format is optional
# io.write_bytes(categ, FORMAT)
# io.write_utf8(stringy)

# buf = io.to_slice
# puts buf

# # decoding -----------------------------

# io2 = IO::Memory.new(buf)

# type2 = io2.read_bytes(UInt8, FORMAT)
# categ2 = io2.read_bytes(UInt16, FORMAT)

# buffer = uninitialized UInt8[1024]
# bytes_read = io2.read_utf8(buffer.to_slice)
# slice = buffer.to_slice[0, bytes_read]
# puts slice
# stringy2 = String.new(slice)

# puts type2
# puts categ2
# puts stringy2
