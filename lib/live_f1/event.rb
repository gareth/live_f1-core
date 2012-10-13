require 'live_f1/enum'

module LiveF1
  # An Event represents a usable metric relating to a car or live session.
  class Event
    module Type
      extend LiveF1::Enum
      RACE = 1
      PRACTICE = 2
      QUALIFYING = 3
    end
    include Type

    module TrackStatus
      extend LiveF1::Enum
    	GREEN_FLAG          = 1
    	YELLOW_FLAG         = 2
    	SAFETY_CAR_STANDBY  = 3
    	SAFETY_CAR_DEPLOYED = 4
    	RED_FLAG            = 5
    end
  end
end