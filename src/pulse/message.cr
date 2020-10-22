# TODO: specs !!!
module Pulse
  class Message
    def initialize()
    end

    def build(parts : Array)
      # TODO: ...
    end

    def parse(binary_message : Slice(UInt8))
      # TODO: ...
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