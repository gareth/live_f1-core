require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Sys::Reset do
  it_behaves_like LiveF1::Packet::Type::Special

  subject { packet }

  let(:source) { mock(:source) }
  let(:header) { mock(:header) }
  let(:data)   { "" }
  let(:packet) do
    packet = described_class.new(source, header)
    packet.send :set_data, data
    packet
  end

  # describe "#inspect" do
  #   it "returns a string representation of the keyframe" do
  #     subject.stub(:number) { 25 }
  #     subject.inspect.should == "Keyframe 25"
  #   end
  # end
end
