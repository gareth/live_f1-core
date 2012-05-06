require 'live_f1/source'

class TestSource < LiveF1::Source
end

module LiveF1
  class Packet
  end
end

describe LiveF1::Source do
  describe "(instance methods)" do
    let(:source) { TestSource.new }
    let(:session) { mock(:session) }
    
    before do
      source.stub(:session) { session }
    end
    
    describe "#run" do
      let(:packets) { [mock("packet"),mock("packet"),mock("packet")] }

      before do
        p = packets ? packets.dup : []
        source.stub(:read_packet) { p.shift }
      end

      context "with keyframes available" do
        let(:keyframe_source) { mock("keyframe source") }
        before do
          source.stub(:keyframe) { keyframe_source }
        end

        it "runs the keyframe" do
          keyframe_source.should_receive(:run)

          source.run { }
        end
      end

      it "reads packets" do
        source.should_receive(:read_packet) { nil }
        source.run { }
      end

      it "yields as many packets as are available" do
        @packets = []
        source.run do |p|
          @packets << p
        end
        @packets.should == packets
      end

      describe "running" do
        let(:header) { mock("header") }
        let(:decryption_key) { "5caff01d".to_i(16) }
        let(:session_number) { 1234 }
        
        before do
          source.stub(:decryption_key).with(session_number) { decryption_key }
        end
        
        context "when an SessionStart packet is yielded" do
          let(:packets) do
            packet = LiveF1::Packet::Sys::SessionStart.new(source, header)
            packet.stub(:session_number) { session_number }
            packet.stub(:event_type) { 3 }
            [packet]
          end
          
          it "creates a source session with the correct data" do
            LiveF1::Source::Session.should_receive(:new).with(1234, 3, decryption_key) { mock(:session) }
            
            source.run { }
          end

          it "sets the source's session to the new session object" do
            LiveF1::Source::Session.stub(:new) { session }
            source.should_receive(:session=).with(session)

            source.run {  }
          end
        end

        context "when an KeyFrame packet is yielded" do
          let(:packets) do
            packet = LiveF1::Packet::Sys::KeyFrame.new(source, header)
            packet.stub(:number) { 123 }
            [packet]
          end
          let(:session) { mock(:session, :reset_decryption_salt! => true) }
          
          before do
            source.stub(:session) { session }
          end
          
          it "resets the session's decryption data" do
            session.should_receive(:reset_decryption_salt!) { true }
            source.run { }
          end

        end
      end
    end

    describe "#read_packet" do
      let(:packet) { mock("packet") }
      let(:session) { mock(:session, :event_type => 3) }

      before do
        LiveF1::Packet.stub(:from_source).with(source, 3) { packet }
        source.session = session
      end

      it "extracts a packet from itself" do
        LiveF1::Packet.should_receive(:from_source).with(source, 3) { packet }

        source.read_packet
      end

      it "returns the extracted packet" do
        source.read_packet.should == packet
      end
    end
    
    describe "#decrypt" do
      let(:input)  { "encrypted" }
      let(:output) { "plaintext" }
      it "calls its session's decryptor" do
        session.should_receive(:decrypt).with(input)
        source.decrypt(input)
      end

      it "returns the decrypted bytes" do
        session.stub(:decrypt) { output }
        source.decrypt(input).should == output
      end
    end
  end
end
