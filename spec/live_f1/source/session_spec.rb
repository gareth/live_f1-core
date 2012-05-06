require 'live_f1/source/session'

describe LiveF1::Source::Session do
  describe "(constructor)" do
    let(:session) { described_class.new(1, 2, 3) }

    it "sets the session number, event type and decryption key" do
      session.number.should == 1
      session.event_type.should == 2
      session.decryption_key.should == 3
    end
    
    it "initializes the decryption salt" do
      session.decryption_salt.should == 0x55555555
    end
  end
  
  describe "(instance methods)" do
    let(:session) { described_class.new(1, 2, 3) }
    
    describe "#decrypt" do
      let(:decryption_key) { "B247A746".to_i(16) }
      let(:encrypted) { "\xBC\x9A\x1E\x9AH>\xCB\xE4\xFE\xE0v!h\r\xF9" }
      let(:decrypted) { "Please Wait ..." }
      it "decrypts data" do
        session.stub(:decryption_key) { decryption_key }
        session.decrypt(encrypted).should == decrypted
      end
    end
    
    describe "#reset_decryption_salt!" do
      it "resets the decryption salt" do
        session.decryption_salt = 0x01010101
        session.reset_decryption_salt!
        session.decryption_salt.should == 0x55555555
      end
    end
  end
end
