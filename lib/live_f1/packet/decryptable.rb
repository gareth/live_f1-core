module LiveF1
  class Packet
    # Packets which mixin the Decryptable module represent data that is encrypted
    # in the data stream.
    # 
    # When setting the packet data we transparently decrypt the data, and also
    # set a raw_data containing the original, encrypted bytes in case they are
    # useful
    module Decryptable
      attr_reader :raw_data
      
      def data= bytes
        @raw_data = bytes
        @data = source.decrypt(bytes)
      end
    end
  end
end
