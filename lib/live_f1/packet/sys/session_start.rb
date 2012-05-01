module LiveF1
  class Packet
    class Sys
      class SessionStart < Sys
        include Packet::Type::Short
        
        def session_number
          data[1..-1].to_i
        end
        
        def event_type
          header.data & 0b0111
        end
        
        def inspect
          "Event #{session_number} Start (#{event_type})"
        end
      end
    end
  end
end
