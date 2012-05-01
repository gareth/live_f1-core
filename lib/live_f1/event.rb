module LiveF1
  class Event
    module Type
      RACE = 1
      PRACTICE = 2
      QUALIFYING = 3
    end
    include Type
  end
end

require_relative 'event/start'