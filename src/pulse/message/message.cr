# TODO: specs !!!
module Pulse
  class Message
    MESSAGE_TYPE_CLASSES = {
      1 => Pulse::Message::Position,
      # TODO: rest...
    }

    FORMAT = IO::ByteFormat::LittleEndian

    def parse(message : Slice(UInt8))
      MESSAGE_TYPE_CLASSES[get_message_type(message)].new.parse(message)
    end

    def get_message_type(message)
      # TODO: return type
    end
  end
end


  # binary message handling

  # FORMAT = IO::ByteFormat::LittleEndian

    #   puts "binary"
  #   puts message # TESTING...
  #   puts message.class # TESTING...

  #   # Converting to message from Slice(UInt8) to Slice(UInt16)
  #   uint16_slice = Slice(UInt16).new(message.to_unsafe.as(Pointer(UInt16)), message.size // 2)

  #   puts "converted to uint16 binary"
  #   puts uint16_slice

  #   puts "Decoding using little endian"

  #   io2 = IO::Memory.new(message)

  #   # typ2 = io2.read_bytes(UInt8, FORMAT)
  #   # categ2 = io2.read_bytes(UInt8, FORMAT)
  #   # usec2 = io2.read_bytes(UInt64, FORMAT)

  #   num1 = io2.read_bytes(UInt16, FORMAT)
  #   num2 = io2.read_bytes(UInt16, FORMAT)

  #   puts num1
  #   puts num2







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

# # decoding

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