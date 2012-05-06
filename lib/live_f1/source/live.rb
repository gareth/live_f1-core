require 'net/http'
require 'cgi'
require_relative 'keyframe'

module LiveF1
  class Source
    class Live < Source

      HOST = "live-timing.formula1.com"
      PORT = 4321

      attr_reader :username, :password

      def initialize username, password
        @username = username
        @password = password
      end

      def read_bytes num
        socket.read(num) or raise EOFError
      end

      def keyframe number = nil
        io = open("http://#{HOST}/#{keyframe_filename(number)}")
        Source::Keyframe.new io, self
      rescue SocketError
        raise ConnectionError, "Unable to connect to live timing server #{HOST}"
      end

      def decryption_key session_number
        open("http://#{HOST}/reg/getkey/#{session_number}.asp?auth=#{auth}").read.to_i(16)
      end

      private
      def socket
        @socket ||= TCPSocket.open(HOST, PORT)
      end

      def auth
        response = Net::HTTP.post_form URI.parse("http://#{HOST}/reg/login.asp"), {"email" => username, "password" => password}
        CGI::Cookie.parse(response["Set-Cookie"])["USER"].first
      end

      def keyframe_filename number
        "keyframe#{ "_%05d" % number if number}.bin"
      end
      
      class ConnectionError < RuntimeError
      end
    end
  end
end
