module LiveF1
  class Packet
    class Sys
      # A SessionStart packet is the first packet emitted for a session.
      class SessionStart < Sys
        include Packet::Type::Short

        # The formula1.com unique identifier for this session
        def session_number
          data[1..-1].to_i
        end

        # The type of event this is (practise, qualifying or race) as defined
        # by the constants in Event::Type
        def event_type
          header.data & 0b0111
        end

        def inspect
          "Event #{session_number} Start (#{Event::Type.name_for event_type})"
        end
      end
    end
  end
end
