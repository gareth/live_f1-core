module LiveF1
  class Packet
    module Type
      module Short
        def length
          l = (header.data >> 3)
          l == 0x0f ? 0 : l
        end
      end

      module Long
        def length
          header.data
        end
      end

      module Special
        def length
          0
        end
      end

      module Timestamp
        def length
          2
        end
      end
    end

    attr_reader :source, :header
    attr_accessor :data

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

    def set_data new_data
      @data = new_data
    end

    def to_s
      data.inspect
    end
    
    def inspect
      "%-23s %s" % [self.class.name.sub(/LiveF1::Packet::/, ''), to_s ]
    end
  end
end


require_relative 'packet/header'
require_relative 'packet/decryptable'
require_relative 'packet/sector_time'
require_relative 'packet/sys'
require_relative 'packet/car'
