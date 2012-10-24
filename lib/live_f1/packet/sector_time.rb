module LiveF1
  class Packet
    module SectorTime

      # Note of which bits appear in packet headers to represent different
      # coloured sectors
      # TODO: Use these colours somewhere
      COLORS = {
        0b010 => :red,
        0b110 => :yellow,
        0b001 => :white,
        0b100 => :purple,
        0b011 => :green
      }

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