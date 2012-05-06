module LiveF1
  class Source
    # A source's Session object holds information about the current state of
    # the data stream, and can use that to decrypt the encrypted packets which
    # are retrieved this way.
    # 
    # = Decryption
    # 
    # Decrypting a string of bytes from the timing stream relies on knowing two
    # pieces of information, a decryption key which is specific to the session
    # in progress, and a decryption salt which starts at a known value but is
    # mutated with every byte that is decrypted.
    # 
    # The decryption key can only be obtained from the live timing servers with
    # a valid formula1.com Live Timing account, as described in
    # LiveF1::Source::Live
    class Session < Struct.new(:number, :event_type, :decryption_key)
      INITIAL_DECRYPTION_SALT = 0x55555555

      attr_accessor :decryption_salt
      
      def initialize number, event_type, decryption_key
        super
        reset_decryption_salt!
      end

      # Decrypts the given string using this session's decryption_key and the
      # current state of the decryption_salt.
      def decrypt input
        input.bytes.map do |b|
          self.decryption_salt = (decryption_salt >> 1) ^ ((decryption_salt & 0x01).zero? ? 0 : decryption_key)
          b ^ (decryption_salt & 0xff)
        end.pack("c*")
      end
      
      def reset_decryption_salt!
        self.decryption_salt = INITIAL_DECRYPTION_SALT
      end
    end
  end
end
