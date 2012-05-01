require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Sys::Timestamp do
  it_behaves_like LiveF1::Packet::Type::Timestamp
  it_behaves_like LiveF1::Packet::Decryptable

  subject { packet }
  
  let(:source) { mock(:source) }
  let(:header) { mock(:header) }
  let(:data)   { "\x03\x00" }
  let(:packet) do
    packet = described_class.new(source, header)
    packet.set_data data
    packet
  end

  describe "#number" do
    # `data` for a KeyFrame packet represents a little-endian integer
    it "read a session number from the data" do
      # Binary: "00000000/00000011"
      subject.set_data [3,0].pack("c*")
      subject.number.should == 3
  
  
      # Binary: "00000001/00000011"
      subject.set_data [3,1].pack("c*")
      subject.number.should == 259
    end
  end
end
