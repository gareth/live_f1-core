module LiveF1
  class Packet
    class Sys
      class Timestamp < Sys
        include Packet::Type::Timestamp
        include Packet::Decryptable
        
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
