module LiveF1
  module Enum
    def name_for event_type
      constants.detect { |c| const_get(c) == event_type }
    end
  end
end