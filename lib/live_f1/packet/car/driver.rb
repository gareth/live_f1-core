module LiveF1
  class Packet
    class Car
      class Driver < Car
        include Packet::Type::Short
        include Packet::Decryptable
        
        def to_s
          data
        end
      end
    end
  end
end
