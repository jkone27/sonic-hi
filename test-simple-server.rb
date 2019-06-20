## works

require 'socket'
port = 2345
server = TCPServer.new('localhost', port)
puts "Listening on port #{port}"

contentLengthRegex = /Content\-Length\:\s(?<length>\d+)/

while session = server.accept
  begin
    bodyLength = 0
    body = "hello"
    while ((request = session.gets) && 
      (!request.chomp.nil?) && 
      (request.chomp.length > 0)) 
      
      matches = contentLengthRegex.match(request.chomp)

      puts request.chomp

      if !matches.nil? then
        begin
	puts matches
        bodyLength = matches["length"].to_i
        rescue 
          puts "error"
        end
      end

    end

    if bodyLength > 0 then
      body = session.read(bodyLength)
    end
        
    response_body = 
    <<-HTML
    <!DOCTYPE html>
    <html>
      <body>
        <h1>#{body}</h1>
      </body>
    </html>
    HTML

    headers = 
    <<-HTTP
    HTTP/1.1 200 OK
    Content-type: text/html
    HTTP

    session.puts headers
    session.puts "\r\n\r\n"
    session.puts response_body
    session.puts "\r\n"
  rescue StandardError => e
    puts "error: " + e.message
    headers = ""
    headers = 
    <<-HTTP
    HTTP/1.1 500 Internal Server Error
    Content-type: text/html
    HTTP

    session.puts headers
    session.puts "\r\n\r\n"
    session.puts e.message
    session.puts "\r\n"
  end
  session.close
end
