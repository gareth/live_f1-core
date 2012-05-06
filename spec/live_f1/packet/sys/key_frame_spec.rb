require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Sys::KeyFrame do
  it_behaves_like LiveF1::Packet::Type::Short

  subject { packet }
  
  let(:source) { mock(:source) }
  let(:header) { mock(:header) }
  let(:data)   { "" }
  let(:packet) do
    packet = described_class.new(source, header)
    packet.send :set_data, data
    packet
  end

  describe "#number" do
    # `data` for a KeyFrame packet represents a little-endian integer
    it "reads its keyframe number from the data" do
      # Binary: "00000000/00000011"
      subject.data = [3,0].pack("c*")
      subject.number.should == 3

      # Binary: "00000001/00000011"
      subject.data = [3,1].pack("c*")
      subject.number.should == 259
    end
  end
  
  # describe "#inspect" do
  #   it "returns a string representation of the keyframe" do
  #     subject.stub(:number) { 25 }
  #     subject.inspect.should == "Keyframe 25"
  #   end
  # end
end
