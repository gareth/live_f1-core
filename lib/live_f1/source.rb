require_relative 'source/live'
require_relative 'source/log'
require_relative 'source/session'
require_relative 'packet'

module LiveF1
  # A Source reads raw live timing data packets from the live timing stream and
  # processes them into semantic packets representing discrete instructions
  # sent from the live timing server.
  #
  # These instructions relate to a low-level manipulation of the screen which
  # would be displayed by the live timing Java applet. For example, when a
  # car's sector 1 time is received, the applet needs to clear the other two
  # sector times from the previous lap:
  #
  #   Driver        Lap       S1    S2    S3
  #   L. HAMILTON   1:35.324  38.4  22.7  34.2
  #
  # becomes
  #
  #   Driver        Lap       S1    S2    S3
  #   L. HAMILTON   1:35.324  39.1
  #
  # However, the live timing stream achieves this by sending three "packets" of
  # data: a sector 1 packet containing "39.1", and sector 2 and 3 packets both
  # containing the empty string "".
  #
  # The methods on a Source instance output all of these packets, even the ones
  # which are useless from a data point of view.
  class Source
    attr_accessor :session

    # Starts processing data from the relevant location, and yields all packets
    # which are generated from the data stream.
    def run
      # We load packets from a couple of places below, but however we get them
      # we treat them the same, hence this proc.
      packet_processor = proc do |packet|
        case packet
        when LiveF1::Packet::Sys::SessionStart
          self.session = Source::Session.new(packet.session_number, packet.event_type, decryption_key(packet.session_number))
        when LiveF1::Packet::Sys::KeyFrame
          session.reset_decryption_salt!
        end
        yield packet
      end

      # The live timing stream starts by loading the most recent Keyframe and
      # reading its data. The keyframe contains "setup" information like driver
      # names and numbers to get the app ready to receive live packets.
      #
      # Importantly we check to see whether the source *knows* about other
      # keyframes. This is because the keyframe is itself another source (the
      # +.run+ we call here is actually this very method on a different
      # subclass)
      if self.respond_to? :keyframe
        keyframe.run(&packet_processor)
      end

      # Now that any keyframe has been parsed, we start streaming raw data
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
