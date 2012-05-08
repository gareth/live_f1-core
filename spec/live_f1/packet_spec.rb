require 'live_f1/packet'
require 'spec_helper'

module LiveF1
  class Packet
    module Spec
      class Base < Packet; def length; 0; end; end
      class Decryptable < Packet; include Packet::Type::Short; include Packet::Decryptable; end
      class Short < Packet; include Packet::Type::Short; end
      class Long < Packet; include Packet::Type::Long; end
      class Special < Packet; include Packet::Type::Special; end
      class Timestamp < Packet; include Packet::Type::Timestamp; end
    end
  end
end

def mock_packet stubs = {}
  base_stubs = {
    :data => "",
    :data= => nil,
    :length => 0
  }
  mock("packet", base_stubs.merge(stubs))
end

extend PacketTypeExamples

describe LiveF1::Packet do
  describe "::from_source" do
    let(:source) { mock("source", :read_bytes => "") }
    let(:header) { mock("header", :packet_klass => LiveF1::Packet::Spec::Base) }
    let(:packet) { mock_packet :length => 7 }
    let(:event_type) { 3 }
    before do
      LiveF1::Packet::Header.stub(:from_source).with(source, event_type) { header }
    end

    it "extracts a packet header from the source" do
      LiveF1::Packet::Header.should_receive(:from_source).with(source, event_type) { header }

      described_class.from_source(source, event_type)
    end

    it "returns the kind of packet specified in the header" do
      described_class.from_source(source, event_type).should be_a_kind_of(LiveF1::Packet::Spec::Base)
    end

    it "reads bytes from the source depending on its determined length" do
      described_class.stub(:new) { packet }

      source.should_receive(:read_bytes).with(7) { "       " }

      described_class.from_source(source, event_type)
    end

    it "sets the packet data to the data read from the source" do
      described_class.stub(:new) { packet }
      source.stub(:read_bytes).with(7) { "abcdefg" }

      packet.should_receive(:data=).with("abcdefg")

      described_class.from_source(source, event_type)
    end
  end

  describe "(constructor)" do
    let(:source) { mock("source") }
    let(:header) { mock("header") }
    let(:packet) { LiveF1::Packet::Spec::Base.new(source, header) }

    it "sets the source property" do
      packet.source.should == source
    end

    it "sets the header property" do
      packet.header.should == header
    end
  end

  describe "(instance methods)" do
    subject { packet }
    let(:source) { mock("source") }
    let(:header) { mock("header", :packet_type => 0, :data => 0) }
    let(:packet) { LiveF1::Packet::Spec::Base.new(source, header) }

    describe "#inspect" do
      it "include the class name" do
        subject.inspect.should include("Spec::Base")
      end
    end
  end
end

describe LiveF1::Packet::Spec::Decryptable do
  it_behaves_like LiveF1::Packet::Decryptable
end

describe LiveF1::Packet::Spec::Long do
  it_behaves_like LiveF1::Packet::Type::Long
end

describe LiveF1::Packet::Spec::Short do
  it_behaves_like LiveF1::Packet::Type::Short
end

describe LiveF1::Packet::Spec::Special do
  it_behaves_like LiveF1::Packet::Type::Special
end

describe LiveF1::Packet::Spec::Timestamp do
  it_behaves_like LiveF1::Packet::Type::Timestamp
end
