require 'live_f1/source'

describe LiveF1::Source::Keyframe do
  let(:io) { mock(:io) }
  let(:parent) { mock(:source) }
  
  describe "(constructor)" do
    let(:source) { described_class.new(io, parent) }
    let(:data) { "" }
    
    it "takes an io object as the first parameter" do
      source.io.should == io
    end

    it "takes a password as the second parameter" do
      source.parent.should == parent
    end
  end
  
  describe "(instance methods)" do
    let(:source) { described_class.new(io, parent) }
    
    describe "#read_bytes" do
      it "reads from the keyframe data" do
        io.should_receive(:read).with(2) { "xx" }
        
        source.read_bytes(2)
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
