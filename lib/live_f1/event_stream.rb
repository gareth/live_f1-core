require_relative 'source'
require_relative 'event'
require 'pp'

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
      timestamp = 0
      weathers = {}
      source.run do |packet|
        # puts packet.inspect
        case packet
        when LiveF1::Packet::Sys::SessionStart
          yield LiveF1::Event::Start.new
        end
      end
    end
  end
end
