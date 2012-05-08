module LiveF1
  class Packet
    class Car
      class PositionUpdate < Car
        include Packet::Type::Special
        
        def to_s
          header.data.to_s
        end
      end
    end
  end
end
