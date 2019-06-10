## not working, to be fixed...

require 'socket'
port = 2345
server = TCPServer.new('localhost', port)
puts "Listening on port #{port}"


while session = server.accept
  begin
    
    puts "go"
    
    session.puts <<-HEREDOC
    HTTP/1.1 200 OK
    Content-type:text/html
    The time is #{Time.now.strftime "%H:%M:%S(%L)"}
    HEREDOC
    
    if ((request = session.gets) && (request.chomp.length > 0)) then
      
      headers = session.recv(1024)
      headers =~ /Content-Length: (\d+)/ # get content length
      body    = $1 ? session.recv($1.to_i) : '' # <- call again to get body if there is one
      
      puts headers +" "+ body
      
    end
    
    #while ((request = session.gets) && (request.chomp.length > 0))
    #print request.chomp
    # playLine(request.chomp)
    #sleep 1
    #end
  rescue Errno::EPIPE
    puts "Connection broke!"
  rescue StandardError => e
    puts e
  end
end
session.close
