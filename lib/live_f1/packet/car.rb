module LiveF1
  class Packet
    class Car < Packet
      def to_s
        "%-39s %s" % [ self.class.name + " (#{header.car})", data.inspect ]
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__),'car','*')].each do |file|
  require file
end
