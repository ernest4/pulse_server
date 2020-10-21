require "kemal"

FORMAT = IO::ByteFormat::LittleEndian

server_memory = 0

# TODO: user redis for game state storage as kemal wont be thread safe once Crystal drops
# true parallelism for fibers

get "/" do
  server_memory = server_memory + 1
  "Hello World! #{server_memory}"
end

# TODO: test websocket if it cna receive byte buffers!!!

# messages = [] of String
# sockets = [] of HTTP::WebSocket

ws "/" do |socket|
  # sockets.push socket

  # Handle incoming message and dispatch it to all connected clients
  socket.on_message do |message|
    # messages.push message
    # sockets.each do |a_socket|
    #   a_socket.send messages.to_json
    # end

    
    puts "non binary"
    puts message # TESTING...
    
    # TESTING: echo
    socket.send(message)
  end

  socket.on_binary do |message|
    # messages.push message
    # sockets.each do |a_socket|
    #   a_socket.send messages.to_json
    # end

    
    puts "binary"
    puts message # TESTING...
    puts message.class # TESTING...

    # Converting to message from Slice(UInt8) to Slice(UInt16)
    uint16_slice = Slice(UInt16).new(message.to_unsafe.as(Pointer(UInt16)), message.size // 2)

    puts "converted to uint16 binary"
    puts uint16_slice

    puts "Decoding using little endian"

    io2 = IO::Memory.new(message)

    # typ2 = io2.read_bytes(UInt8, FORMAT)
    # categ2 = io2.read_bytes(UInt8, FORMAT)
    # usec2 = io2.read_bytes(UInt64, FORMAT)

    num1 = io2.read_bytes(UInt16, FORMAT)
    num2 = io2.read_bytes(UInt16, FORMAT)

    puts num1
    puts num2
    
    # TESTING: echo
    socket.send(message) # sending and receiving, all in single bytes...
  end

  # Handle disconnection and clean sockets
  socket.on_close do |_|
    # sockets.delete(socket)
    puts "Closing Socket: #{socket}"
  end
end


Kemal.run




# TEST deploying this on heroku as is. Do websockets work or not!!!!????