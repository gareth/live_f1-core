module LiveF1
  class Packet
    class Car
      class Position < Car
        include Packet::Type::Short
        include Packet::Decryptable
        
        def to_s
          data.to_s
        end
      end
    end
  end
end
