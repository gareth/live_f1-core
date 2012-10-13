require 'spec_helper'
require 'live_f1/source'

describe LiveF1::Source::Live do
  let(:username) { "username@example.com" }
  let(:password) { "swordfish" }

  describe "(constructor)" do
    let(:source) { described_class.new(username, password) }

    it "takes a username as the first parameter" do
      source.username.should == username
    end

    it "takes a password as the second parameter" do
      source.password.should == password
    end
  end

  describe "(instance methods)" do
    let(:source) { described_class.new(username, password) }

    describe "#read_bytes" do
      let(:socket) { mock(:socket) }
      it "reads from the live f1 socket" do
        source.stub(:socket) { socket }
        socket.should_receive(:read).with(2) { "xx" }

        source.read_bytes(2)
      end
    end

    describe "#socket" do
      it "opens a TCPSocket to the live timing server" do
        TCPSocket.should_receive(:open).with("live-timing.formula1.com", 4321) { mock("socket") }
        source.send(:socket)
      end

      it "uses an existing socket if available" do
        TCPSocket.should_receive(:open).once { mock("socket") }
        source.send(:socket)
        source.send(:socket)
      end
    end

    describe "#keyframe" do
      let(:io) { mock(:io) }

      context "without a keyframe number" do
        it "returns a Keyframe source initialised with the correct URL and parent source" do
          source.should_receive(:open).with("http://live-timing.formula1.com/keyframe.bin") { io }
          LiveF1::Source::Keyframe.should_receive(:new).with(io, source)

          source.keyframe
        end
      end

      context "with a keyframe number" do
        it "returns a Keyframe source initialised with the correct URL and parent source" do
          source.should_receive(:open).with("http://live-timing.formula1.com/keyframe_00012.bin") { io }
          LiveF1::Source::Keyframe.should_receive(:new).with(io, source)

          source.keyframe(12)
        end
      end

      context "on SocketError" do
        before do
          source.stub(:open).and_raise(SocketError)
        end

        it "raises ConnectionError" do
          lambda { source.keyframe }.should raise_error(LiveF1::Source::Live::ConnectionError)
        end
      end
    end

    describe "#decryption_key" do
      let(:decryption_url) { "http://live-timing.formula1.com/reg/getkey/1234.asp?auth=ABC123DEF" }

      before do
        source.stub(:auth) { "ABC123DEF" }
      end

      it "uses the live source's authorization to request decryption key from the live timing servers" do
        source.should_receive(:open).with(decryption_url) { mock(:io, :read => "5caff01d") }
        source.decryption_key(1234).should == "5caff01d".to_i(16)
      end
    end

    describe "#auth" do
      before do
        FakeWeb.register_uri :post, "http://live-timing.formula1.com/reg/login", :set_cookie => "USER=abcdef"
      end

      it "loads authentication from the live timing servers" do
        source.send(:auth).should == "abcdef"
      end
    end
  end
end