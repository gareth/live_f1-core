require 'net/http'
require 'cgi'
require 'timeout'
require 'fileutils'
require 'yaml'
require_relative 'keyframe'

module LiveF1
  class Source
    class Live < Source

      HOST = "80.231.178.249"
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
        log.keyframe(number, io.read) if number
        log.flush
        io.rewind
        Source::Keyframe.new io, self
      rescue SocketError
        raise ConnectionError, "Unable to connect to live timing server #{HOST}"
      end

      def decryption_key session_number
        return if session_number.zero?
        key = open("http://#{HOST}/reg/getkey/#{session_number}.asp?auth=#{auth}").read.to_i(16)
        raise ConnectionError, "Unable to access session key for session #{session_number}. This could indicate incorrect credentials or an issue with the formula1.com key server" if key.zero?
        key
      end

      # Sets the base directory for live data log files to be stored
      def log_dir= log_directory
        Log.dir = log_directory
      end

      def run
        super do |packet|
          case packet
          when LiveF1::Packet::Sys::SessionStart
            log.start packet.session_number
            log.key session.decryption_key
          when LiveF1::Packet::Sys::KeyFrame
            keyframe(packet.number)
          end

          log.packet packet

          yield packet
        end
      rescue Errno::ECONNRESET
        log.reset
        retry
      rescue Exception
        log.reset
        raise
      end

      def session= new_session
        super
      end

      def log
        LogProxy
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

      # Wraps a logfile in methods which mean the caller doesn't need to know
      # if a log is currently open or not
      class LogProxy # :nodoc:
        class << self
          def start session_number
            reset
            @log = Log.new session_number unless session_number.zero?
          end

          [:key, :packet, :keyframe].each do |m|
            define_method m do |*args|
              @log.send(m, *args) if @log
            end
          end

          # Writes the current logfile to disk
          def flush
            @log.flush if @log
          end

          # Writes the current logfile to disk and then closes the log
          def reset
            flush
            @log = nil
          end
        end
      end

      class Log
        class << self
          attr_accessor :dir

          def dir= log_directory
            @dir = Pathname.new(log_directory).join(Date.today.strftime("%Y%m%d"))
            FileUtils.mkdir_p(@dir)
          end

          # Has logging been set up (do we have a log directory to write to)?
          def active?
            !!@dir
          end
        end

        def initialize session_number
          @filename = Log.dir.join("%s.%s.f1" % [session_number, Time.now.strftime("%H%M%S")]) if Log.active?
          @data = {
            key: nil,
            bytes: "",
            keyframes: {},
          }
        end

        # Adds a decryption key to this log
        def key key
          @data[:key] = key
        end

        # Adds a packet to this log's bytestream
        def packet packet
          @data[:bytes] << packet.header.bytes << packet.bytes
        end

        # Adds keyframe `n` to this log
        def keyframe number, keyframe_bytes
          @data[:keyframes][number] = keyframe_bytes
        end

        # Writes this logfile to disk
        def flush
          File.open(@filename, "w") { |f| f.write YAML.dump(@data) } if @filename
        end
      end

      class ConnectionError < RuntimeError
      end
    end
  end
end
