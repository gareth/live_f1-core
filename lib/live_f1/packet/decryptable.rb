module LiveF1
  class Packet
    module Decryptable
      attr_reader :raw_data
      
      def data= bytes
        @raw_data = bytes
        @data = source.decrypt(bytes)
      end
    end
  end
end
