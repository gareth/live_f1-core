module LiveF1
  class Source
    class Session < Struct.new(:number, :event_type, :decryption_key)
      INITIAL_DECRYPTION_SALT = 0x55555555

      attr_accessor :decryption_salt
      def initialize number, event_type, decryption_key
        super
        reset!
      end

      def decrypt bytes # :nodoc:
        (bytes||"").bytes.map do |b|
          self.decryption_salt = (decryption_salt >> 1) ^ ((decryption_salt & 0x01).zero? ? 0 : decryption_key)
          b ^ (decryption_salt & 0xff)
        end.pack("c*")
      end
      
      def reset!
        self.decryption_salt = INITIAL_DECRYPTION_SALT
      end
    end
  end
end
