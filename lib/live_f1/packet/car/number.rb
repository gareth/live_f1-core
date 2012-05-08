module LiveF1
  class Packet
    class Car
      class Number < Car
        include Packet::Type::Short
        include Packet::Decryptable
        
        def to_s
          "%02d" % data.to_i unless data == ""
        end
      end
    end
  end
end
