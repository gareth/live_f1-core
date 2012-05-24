module LiveF1
  class Packet
    class Car
      class PitCount < Car
        include Packet::Type::Short
        include Packet::Decryptable
        
        def number
          data.to_i
        end
        
        def to_s
          number
        end
      end
    end
  end
end
