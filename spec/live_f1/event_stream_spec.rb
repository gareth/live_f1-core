require 'live_f1/event_stream'

describe LiveF1::EventStream do
  describe "(constructor)" do
    let(:source) { mock("source") }
    let(:event_stream) { described_class.new(source) }

    it "takes a source as the first parameter" do
      event_stream.source.should == source
    end
  end

  describe "::live" do
    let(:username) { "username@example.com" }
    let(:password) { "password" }
    let(:source) { mock("live source") }

    before do
      LiveF1::Source::Live.stub(:new).with(username, password).and_return(source)
    end

    it "initializes a live timing source" do
      LiveF1::Source::Live.should_receive(:new).with(username, password)

      LiveF1::EventStream.live(username, password)
    end

    it "sets the source property of the event stream" do
      stream = LiveF1::EventStream.live(username, password)

      stream.source.should == source
    end
  end

  describe "(instance methods)" do
    let(:source) { stub("source") }
    let(:event_stream) { described_class.new(source) }

    describe "#run" do
      it "runs its source" do
        source.should_receive(:run)

        event_stream.run { }
      end
    end
  end

end
