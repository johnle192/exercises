# This is my attempt at building a naive
# HTTP server to understand what HTTP is

require 'socket'               # Get sockets from stdlib

class ParseHTTPRequest
  def parse_request(request_line, headers)
    parse_request_line(request_line)
    parsed_request = {
      'method'  => @verb,
      'path'    => @path,
      'version' => @version,
      'headers' => parse_headers(headers)
    }
  end

  private

  def parse_request_line(request_line)
    request_line.gsub!("\r\n",'')
    @verb, @path, @version = request_line.split(' ')
  end

  def parse_headers(headers)
    array_headers = headers.map do |header|
      header.chomp!
      header.split(': ')
    end

    Hash[array_headers]
  end
end

class BuildHTTPResponse
  def build(request)
    body = "<div style='color: red'> #{request['path']} </div>"
    content_length = body.bytesize

    status_line = "#{request['version']} 200 OK\r\n"

    headers = [
      "Content-Type: text/html\r\n",
      "Content-Length: #{content_length}\r\n",
      "Connection: close\r\n",
      "\r\n"
    ]

    return [status_line, headers, body].flatten
  end
end

server = TCPServer.open(2000)
loop {
  client = server.accept
  headers = []
  request_line = client.gets
  while (request_header = client.gets).chomp != ""
    headers << request_header
  end

  parsed_request =  ParseHTTPRequest.new.parse_request(request_line, headers)

  response = BuildHTTPResponse.new.build(parsed_request)
  client.puts response
  client.puts

  client.close
}
