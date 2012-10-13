module LiveF1
  class Packet
    class Sys
      class Reset < Sys
        include Packet::Type::Special
      end
    end
  end
end
