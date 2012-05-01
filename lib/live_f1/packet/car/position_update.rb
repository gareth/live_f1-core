module LiveF1
  class Packet
    class Car
      class PositionUpdate < Car
        include Packet::Type::Special
      end
    end
  end
end
