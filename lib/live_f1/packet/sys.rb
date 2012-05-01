module LiveF1
  class Packet
    class Sys < Packet
    end
  end
end

Dir[File.join(File.dirname(__FILE__),'sys','*')].each do |file|
  require file
end
