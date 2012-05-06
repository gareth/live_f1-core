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
  @stream = LiveF1::EventStream.live 'gareth@example.com', 'swordfish'
end

Then /^I should receive packets of data$/ do
  packets = []
  @stream.run do |packet|
    packets << packet
  end
  packets.should include_a(LiveF1::Event::Start)
end

def fixture_session name
  fixture_base = File.expand_path(File.join(File.dirname(__FILE__),'../fixtures/sessions',name))
  session_filename = Dir[File.join(fixture_base,'*.bin')].first
  # puts "USING SESSION #{session_filename}"
  file = File.open(session_filename)
  TCPSocket.stub(:open) { file }
  # Stub HTTP requests for keyframes
  Dir[File.join(fixture_base,'keyframe','*')].each do |path|
    base = File.basename(path)
    url = "http://live-timing.formula1.com/#{base}"
    FakeWeb.register_uri(:get, url, :body => path)
  end
  keyfile = Dir[File.join(fixture_base,'session','*.key')].first
  session_number = File.basename(keyfile, '.key')
  FakeWeb.register_uri(:post, 'http://live-timing.formula1.com/reg/login.asp', :set_cookie => "USER=abc123def")
  FakeWeb.register_uri(:get,  "http://live-timing.formula1.com/reg/getkey/#{session_number}.asp?auth=abc123def", :body => keyfile)
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
