module LiveF1
  # Adds a convenience method for converting between constant values and names
  module Enum
    # Returns the first constant (in definition order) matching the given value
    def name_for value
      constants.detect { |c| const_get(c) == value }
    end
  end
end