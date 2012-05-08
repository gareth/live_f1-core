module LiveF1
  class Packet
    class Car < Packet
      def leader
        super.gsub(/Car/) { "Car(%02d)" % header.car }
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__),'car','*')].each do |file|
  require file
end
