module LiveF1
  class Packet
    module SectorTime
      def seconds
        if match = data.match(/^(?:(\d+):)?(\d+.\d+)$/)
          _, minutes, seconds = match.to_a
          (Rational(minutes.to_i * 60) + Rational(seconds)).to_f
        end
      end

      def to_s
        seconds || data
      end
    end
  end
end