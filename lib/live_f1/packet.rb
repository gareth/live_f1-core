module LiveF1
  # A Packet represents a raw instruction sent from the live timing server to
  # the live timing applet.
  # 
  # It is represented in the data stream by a variable-length series of bytes,
  # always starting with a 2-byte "header" and then a number of other bytes
  # depending on the specific data being represented.
  class Packet
    # There are 4 broad categories of packet, where the only difference is how
    # we work out how many bytes of data are expected from the stream
    module Type
      module Short
        # Short packets use 4 bits of the header data to represent the packet
        # length. Normally this would mean a maximum length of 15, except if a
        # short packet says it has a length of 15 it actually has a length of 0
        def length
          l = (header.data >> 3)
          l == 0x0f ? 0 : l
        end
        
        def spare_bits
          3
        end
      end

      module Long
        # Long packets use all 7 bits of the header data to represent the packet
        # length. This allows for a maximum packet length of 127 bytes.
        def length
          header.data
        end
        
        def spare_bits
          0
        end
      end

      module Special
        # Special packets never have any additional data.
        def length
          0
        end
        
        def spare_bits
          7
        end
      end

      module Timestamp
        # Timestamp packets always contain 2 bytes of data.
        def length
          2
        end
        
        def spare_bits
          7
        end
      end
    end

    attr_reader :source
    attr_reader :header
    attr_accessor :data

    # First extracts a Header from the given source and then extracts the
    # packet it represents, based on the given event type.
    def self.from_source source, event_type
      header = Header.from_source(source, event_type)
      packet = header.packet_klass.new source, header
      data = source.read_bytes(packet.length)
      packet.data = data
      packet
    end

    def initialize source, header
      @source = source
      @header = header
    end

    def to_s
      data.inspect
    end
    
    def spare_bits
      0
    end
    
    def spare_data
      "%0#{spare_bits}b" % (header.data & (2 ** spare_bits - 1))
    end
    
    def inspect
      "[%7s] %-23s %s" % [spare_data, leader, to_s ]
      "%-23s %s" % [leader, to_s ]
    end
    
    def leader
      self.class.name.sub(/LiveF1::Packet::/, '')
    end

    private
    # Since some classes override +data=+ to deal with encrypted data, here's a
    # method that can be used in rare cases (e.g. testing) where we need to
    # bypass that process
    def set_data new_data
      @data = new_data
    end
  end
end


require_relative 'packet/header'
require_relative 'packet/decryptable'
require_relative 'packet/sector_time'
require_relative 'packet/sys'
require_relative 'packet/car'
