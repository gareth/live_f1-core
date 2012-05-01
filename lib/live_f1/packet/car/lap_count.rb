module LiveF1
  class Packet
    class Car
      class LapCount < Car
        include Packet::Type::Short
        include Packet::Decryptable
      end
    end
  end
end
