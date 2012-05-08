module LiveF1
  class Packet
    class Sys
      class TrackStatus < Sys
        include Packet::Type::Short
        include Packet::Decryptable
        
        def status
          data.to_i
        end
        
        def to_s
          Event::TrackStatus.name_for(status)
        end
      end
    end
  end
end
