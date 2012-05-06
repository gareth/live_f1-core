module LiveF1
  class Packet
    class Sys
      # Individual packets don't include any timestamp data to indicate when
      # they happened. However, at selected (but irregular) intervals Timestamp
      # packets are emitted containing the number of seconds since the start of
      # the session.
      class Timestamp < Sys
        include Packet::Type::Timestamp
        include Packet::Decryptable
        
        # The number of seconds since the start of the session.
        def number
					data.unpack("v").first
        end
        
        def to_s
          number
        end
      end
    end
  end
end
