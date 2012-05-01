require_relative 'source'
require_relative 'event'

module LiveF1
  class EventStream
    attr_reader :source

    def self.live username, password
      source = LiveF1::Source::Live.new(username, password)
      new(source)
    end

    def initialize source
      @source = source
    end

    def run
      source.run do |packet|
        # puts packet
        case packet
        when LiveF1::Packet::Sys::SessionStart
          yield LiveF1::Event::Start.new
        end
      end
    end
  end
end
