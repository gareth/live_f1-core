module LiveF1
  # Adds a debug accessor to trigger extra debugging within the module
  class << self
    attr_accessor :debug
  end
end