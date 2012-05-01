require 'live_f1/packet'
require 'rspec/core/shared_context'

module PacketTypeExamples
  extend RSpec::Core::SharedContext
  
  shared_examples LiveF1::Packet::Type::Long do
    subject { described_class.new(source, header) }

    let(:source) { mock("source") }
    let(:header) { mock("header", :packet_klass => described_class, :data => "0100000".to_i(2)) }

    # Long packets use the header data to represent the length
    it "gets length from the header" do
      subject.length.should == 32
    end
  end

  shared_examples LiveF1::Packet::Type::Short do
    subject { described_class.new(source, header) }

    let(:source) { mock("source") }
    let(:data) { "0100000".to_i(2) }
    let(:header) { mock("header", :packet_klass => described_class, :data => data) }

    # Short packets use the left-hand 4 bits of the header data to represent the length
    it "gets length from the header" do
      subject.length.should == 4
    end

    # except when the data would otherwise be 15, in which case it's length 0
    context "when the header data would indicate length 15" do
      let(:data) { "1111000".to_i(2) }

      it "gets zero length from the header" do
        subject.length.should == 0
      end
    end
  end

  shared_examples LiveF1::Packet::Type::Special do
    subject { described_class.new(source, header) }

    let(:source) { mock("source") }
    let(:header) { mock("header", :packet_klass => described_class, :data => "0100000".to_i(2)) }

    # Special packets never have any packet data
    it "has length 0" do
      subject.length.should == 0
    end
  end

  shared_examples LiveF1::Packet::Type::Timestamp do
    subject { described_class.new(source, header) }

    let(:source) { mock("source") }
    let(:header) { mock("header", :packet_klass => described_class, :data => "0100000".to_i(2)) }

    # Timestamp packets have a fixed length, regardless of the data
    it "has length 2" do
      subject.length.should == 2
    end
  end
  
  shared_examples LiveF1::Packet::Decryptable do
    subject { described_class.new(source, header) }
    
    # let(:decryption_key) { "AF661706" }
    # let(:data) { "\xBC\x9A\x1E\x9AH>\xCB\xE4\xFE\xE0v!h\r\xF9" }

    let(:source) { mock("source") }
    let(:header) { mock("header", :packet_klass => described_class, :data => "0100000".to_i(2)) }
    
    before do
      source.stub(:decrypt) { "plaintext" }
    end
    
    it "decrypts data passed to it" do
      source.should_receive(:decrypt).with("encrypted") { "plaintext" }

      subject.data = "encrypted"

      subject.data.should == "plaintext"
    end
    
    it "sets the packet's raw data" do
      subject.data = "encrypted"

      subject.raw_data.should == "encrypted"
    end
  end
end
