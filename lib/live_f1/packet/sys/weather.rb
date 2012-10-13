require 'live_f1/enum'

module LiveF1
  class Packet
    class Sys
      class Weather < Sys
        module Metric
          extend LiveF1::Enum
        	SESSION_CLOCK     = 0
        	TRACK_TEMPERATURE = 1
        	AIR_TEMPERATURE   = 2
        	WET_TRACK         = 3
        	WIND_SPEED        = 4
        	HUMIDITY          = 5
        	AIR_PRESSURE      = 6
        	WIND_DIRECTION    = 7
        end
        include Metric

        include Packet::Type::Short
        include Packet::Decryptable

        def to_s
          "%-18s - %s" % [Metric.name_for(metric), data]
        end

        def metric
          header.data & 0b0111
        end
      end
    end
  end
end
