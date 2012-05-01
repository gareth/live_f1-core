module LiveF1
  class Packet
    class Sys
      class Speed < Sys
        include Packet::Type::Long
        include Packet::Decryptable
      end
    end
  end
end
