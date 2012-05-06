module LiveF1
  # An Event represents a usable metric relating to a car or live session.
  class Event
    module Type
      RACE = 1
      PRACTICE = 2
      QUALIFYING = 3
      def self.name_for event_type
        constants.detect { |c| const_get(c) == event_type }
      end
    end
    include Type
  end
end

require_relative 'event/start'