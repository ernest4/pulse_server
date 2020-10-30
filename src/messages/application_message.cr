# TODO: specs !!!

module Pulse
  module Messages
    abstract class ApplicationMessage
      class IOMemoryWrapper
        def initialize
          @io_memory = IO::Memory.new
        end

        def initialize(buffer)
          @io_memory = IO::Memory.new(buffer)
        end

        # delegate to_slice, to: @io_memory # delegates known methods
        forward_missing_to @io_memory # delegates any unimplemented methods

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

        def get_byte
          @io_memory.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        end

        def get_number(size = UInt16)
          @io_memory.read_bytes(size, IO::ByteFormat::LittleEndian)
        end

        def get_string
          # TODO: ... pick optimal buffer size ...
          # or maybe different methods for different string sizes ?!?
          buffer = uninitialized UInt8[1024]
          bytes_read = @io_memory.read_utf8(buffer.to_slice)
          slice = buffer.to_slice[0, bytes_read]
          # puts slice
          String.new(slice)
        end
      end

      def parse(message : Slice(UInt8))
        io_memory_message = IOMemoryWrapper.new(message)
        io_memory_message.get_byte # extracting out the message type...

        yield io_memory_message
      end

      def to_message_slice(message_type)
        new_io_memory_message = IOMemoryWrapper.new
        new_io_memory_message.set_byte(message_type) # inserting the message type...

        yield new_io_memory_message

        new_io_memory_message.to_slice
      end

      abstract def to_slice
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
