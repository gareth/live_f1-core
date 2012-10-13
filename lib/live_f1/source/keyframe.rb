require 'open-uri'

module LiveF1
  class Source
    class Keyframe < Source
      attr_reader :io, :parent

      def initialize io, parent
        @io = io
        @parent = parent
      end

      def read_bytes num
        io.read(num) or raise EOFError
      end

      def session
        parent.session
      end

      def session= new_session
        parent.session = new_session
      end

      def decryption_key session_number
        parent.decryption_key(session_number)
      end
    end
  end
end
