require 'live_f1/source'

describe LiveF1::Source::Keyframe do
  let(:url) { "http://example.com/keyframe.bin" }
  let(:parent) { mock(:source) }
  
  describe "(constructor)" do
    let(:source) { described_class.new(url, parent) }
    let(:data) { "" }
    
    it "takes a username as the first parameter" do
      source.url.should == url
    end

    it "takes a password as the second parameter" do
      source.parent.should == parent
    end
  end
  
  describe "(instance methods)" do
    let(:source) { described_class.new(url, parent) }
    
    describe "#read_bytes" do
      let(:stream) { mock("stream") }
      it "reads from the keyframe data" do
        source.stub(:stream) { stream }
        stream.should_receive(:read).with(2) { "xx" }
        
        source.read_bytes(2)
      end
    end
    
    describe "#stream" do
      it "loads the supplied URL and memoizes it" do
        source.should_receive(:open).once.with(url) { "" }
        source.send(:stream)
        source.send(:stream)
      end
    end
    
    describe "#session" do
      it "uses its parent source's session" do
        session = mock(:session)
        parent.stub(:session) { session }
        source.session.should == session
      end
    end
    
    describe "#session=" do
      it "sets its parent source's session" do
        session = mock(:session)
        parent.should_receive(:session=).with(session)

        source.session = session
      end
    end
    
    describe "#decryption_key" do
      it "uses its parent source's decryption key" do
        parent.should_receive(:decryption_key).with(1234) { "5caff01d" }
        
        source.decryption_key(1234).should == "5caff01d"
      end
    end
  end
end
