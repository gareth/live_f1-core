require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Sys::SessionStart do
  it_behaves_like LiveF1::Packet::Type::Short

  subject { packet }
  
  let(:source) { mock(:source) }
  let(:header) { mock(:header, :data => "0000010".to_i(2)) }
  let(:data)   { "\x005678" }
  let(:packet) do
    described_class.new(source, header).tap do |packet|
      packet.send :set_data, data
    end
  end
  
  describe "#session_number" do
    it "reads a session number from the data" do
      subject.session_number.should == 5678
    end
  end
  
  describe "#event_type" do
    it "returns the event type indicated in the first data byte" do
      subject.event_type.should == 2
    end
  end
end
