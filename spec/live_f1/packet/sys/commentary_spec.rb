require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Sys::Commentary do
  it_behaves_like LiveF1::Packet::Type::Long
  it_behaves_like LiveF1::Packet::Decryptable

  subject { packet }
  
  let(:source) { mock(:source) }
  let(:header) { mock(:header) }
  let(:data)   { "" }
  let(:packet) do
    packet = described_class.new(source, header)
    packet.send :set_data, data
    packet
  end
  
  describe "#terminal?" do
    context "when the data contains a byte indicating terminality" do
      let(:data) { "\x01\x01A commentary line without a subsequent line" }

      it "marks the packet as terminal" do
        subject.should be_terminal
      end
    end

    context "when the data contains a byte indicating non-terminality" do
      let(:data) { "\x01\x00A commentary line with a subsequent line" }

      it "marks the packet as non-terminal" do
        subject.should_not be_terminal
      end
    end
  end
  
  describe "#line" do
    let(:data) { "\x01\x01A commentary line without a subsequent line" }
    it "returns the data without the initial flags" do
      subject.line.should == "A commentary line without a subsequent line"
    end
  end
end
