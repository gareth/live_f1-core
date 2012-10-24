require_relative 'keyframe'

module LiveF1
  class Source
    class Log < Source

      attr_reader :file, :data

      def initialize file
        @file = file
        @data = YAML.load(@file.read)
        @bytes = StringIO.new(@data[:bytes])
      end

      def read_bytes num
        @bytes.read(num)
      end

      def keyframe number = nil
        keyframe_data = data[:keyframes][number.to_s] || ""
        Source::Keyframe.new StringIO.new(keyframe_data), self
      end

      def decryption_key session_number
        data[:key].to_i
      end
    end
  end
end
