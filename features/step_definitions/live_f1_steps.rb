$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'live_f1'
require 'cucumber/rspec/doubles'

Given /^the live timing session is about to start$/ do
  # fixture_session '2012.04.bahrain.practice.2'
  fixture_session '2012.03.china.qualifying'
end

Given /^the live timing session has been completed$/ do
  fixture_session '2012.05.bahrain.race.post'
end

When /^I successfully connect to the live timing service$/ do
  @stream = LiveF1::Source::Live.new 'gareth@example.com', 'swordfish'
end

Then /^I should receive packets of data$/ do
  packets = []
  @stream.run do |packet|
    packets << packet
  end
  packets.should include_a(LiveF1::Packet::Sys::SessionStart)
end

def fixture_session name
  fixture_base = File.expand_path(File.join(File.dirname(__FILE__),'../fixtures/sessions',name))

  stream_filename = File.join(fixture_base,'session.bin')
  # Stubbing a Socket with a File may have consequences
  TCPSocket.stub(:open) { File.open(stream_filename) }

  sessions = Dir[File.join(fixture_base,'*')].select { |f| File.directory? f }
  sessions.each do |session|
    keyframe_data = YAML.load(File.read(File.join(session, "keyframes.yaml")))
    keyframe_data.each do |filename, data|
      url = "http://80.231.178.249/#{filename}"
      FakeWeb.register_uri(:get, url, :body => data)
    end

    session_number = File.basename(session)
    keyfile = File.join(session,'session.key')
    FakeWeb.register_uri(:post, 'http://80.231.178.249/reg/login', :set_cookie => "USER=abc123def")
    FakeWeb.register_uri(:get,  "http://80.231.178.249/reg/getkey/#{session_number}.asp?auth=abc123def", :body => keyfile)
  end
end

# def live_timing_session &block
#   receiver = Object.new
#   class << receiver
#     attr_writer :packets
#
#     def packets
#       @packets ||= []
#     end
#
#     def method_missing m, *args
#       self.packets += MockPacket.send(m, *args)
#     end
#   end
#
#   yield receiver
#
#   receiver.packets << nil
#
#   socket = mock("socket")
#   socket.stub(:read) { receiver.packets.shift }
#   TCPSocket.stub(:open) { socket }
# end
