require 'open-uri'

module LiveF1
  class Source
    class Keyframe < Source
      attr_reader :url, :parent

      def initialize url, parent
        @url = url
        @parent = parent
      end

      def read_bytes num
        stream.read(num) or raise EOFError
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
      
      private
      def stream
        @io ||= open(url)
      end
    end
  end
end
