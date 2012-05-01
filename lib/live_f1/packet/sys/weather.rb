module LiveF1
  class Packet
    class Sys
      class Weather < Sys
        include Packet::Type::Short
        include Packet::Decryptable
      end
    end
  end
end
