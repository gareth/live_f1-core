module LiveF1
  class Packet
    class Car
      class Period1 < Car
        include Packet::Type::Short
        include Packet::Decryptable
        include Packet::SectorTime
      end
    end
  end
end
