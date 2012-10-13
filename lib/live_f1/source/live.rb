require 'net/http'
require 'cgi'
require 'timeout'
require 'fileutils'
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
        begin
          Timeout.timeout(0.5) do
            socket.read(num) or raise EOFError
          end
        rescue Timeout::Error, Errno::ETIMEDOUT => e
          socket.write("\n")
          socket.flush
          retry
        end
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

      # Sets the base directory for live data log files to be stored
      def log_dir= log_directory
        @log_dir = Pathname.new(log_directory).join(Date.today.strftime("%Y%m%d"))
        FileUtils.mkdir_p(@log_dir)
      end

      def session= new_session
        super
      end

      private
      def socket
        @socket ||= TCPSocket.open(HOST, PORT)
      end

      def auth
        response = Net::HTTP.post_form URI.parse("http://#{HOST}/reg/login"), {"email" => username, "password" => password}
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
