module LiveF1
  class Packet
    class Sys
      class KeyFrame < Sys
        include Packet::Type::Short
        
        def number
					data.reverse.unpack("B*").first.to_i(2)
        end
        
        def to_s
          "Keyframe #{number}"
        end
      end
    end
  end
end