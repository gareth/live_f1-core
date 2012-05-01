module LiveF1
  class Packet
    module SectorTime
      def seconds
        unless data == ""
          seconds, minutes = data.split(":").reverse
          (Rational(minutes.to_i * 60) + Rational(seconds)).to_f
        end
      end
      
      def to_s
        seconds
      end
    end
  end
end