module LiveF1
  class Packet
    class Car
      class PositionHistory < Car
        include Packet::Type::Long
        include Packet::Decryptable

        def to_s
          data.bytes.map(&:to_i).inspect
        end
      end
    end
  end
end
