# This is an exercise for me to understand what TCP, IP, and sockets are
# You can start the server by running 'ruby echo_server.rb'
# And hitting the socket with 'telnet localhost 2000' in another window
# You should be able to type in the telnet window to see what the server received
require 'socket'               # Get sockets from stdlib

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  loop {
    string = client.readline
    if string == "close\r\n"
      print "Closing the client"; 4.times {  print '.'; sleep 1 }; puts "  Closed"
      break
    else
      client.puts "Received: #{string}"
      puts "Received: #{string}"
    end
  }
  client.close                 # Disconnect from the client
}
