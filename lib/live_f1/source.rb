require_relative 'source/live'
require_relative 'source/session'
require_relative 'packet'

module LiveF1
  class Source
    # When a source is set to a particular session state, all packets generated
    # by that source will be relevant to that kind of session
    attr_accessor :session

    def run
      packet_processor = proc do |packet|
        case packet
        when LiveF1::Packet::Sys::SessionStart
          self.session = Source::Session.new(packet.session_number, packet.event_type, decryption_key(packet.session_number))
        when LiveF1::Packet::Sys::KeyFrame
          session.reset!
        end
        yield packet
      end

      if self.respond_to? :keyframe
        keyframe.run(&packet_processor)
      end
      while packet = read_packet
        packet_processor.call(packet)
      end
    end
    
    def decrypt bytes
      session.decrypt bytes
    end

    def read_packet
      Packet.from_source(self, (session.event_type if session))
    rescue EOFError
    end

    def read_bytes num
      raise NotImplementedError, "#read_bytes should be implemented by #{self.class}"
    end

    def decryption_key session_number
      raise NotImplementedError, "#decryption_key should be implemented by #{self.class}"
    end
  end
end
