module LiveF1
  class Packet
    class Sys
      class Speed < Sys
        include Packet::Type::Long
        include Packet::Decryptable

        def trap
          data.bytes.first
        end

        def speeds
          data[1..-1].split(/\s+/).each_slice(2).map { |d,s| "%s: %d" % [d,s] }.join(", ")
        end

        def to_s
          out = case trap
          when 1..4
            speeds
          else
            data[1..-1]
          end

          "[%d] %s" % [trap, out]
        end
      end
    end
  end
end
