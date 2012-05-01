require 'live_f1/packet'
require 'live_f1/event'

describe LiveF1::Packet::Header do
  describe "::from_source" do
    let(:source) { mock("source") }
    let(:event_type) { 13 }

    it "reads 2 bytes from the source" do
      described_class.stub(:new)
      source.should_receive(:read_bytes).with(2) { "  " }
      described_class.from_source(source, nil)
    end

    it "generates a Header with the correct attributes" do
      # Header data is packed into 2 bytes
      # MASK: bbbcccccaaaaaaab/bbb
      # a:            0000001      = 1
      # b:                   0/011 = 3 (wrapped)
      # c:       00111             = 7
      bits = "0110011100000010"
      source.stub(:read_bytes) { [bits].pack("B*") }
      described_class.should_receive(:new).with(1, 3, 7, event_type) { stub("header") }

      described_class.from_source(source, event_type)
    end
  end

  describe "(constructor)" do
    let(:header) { described_class.new(1, 2, 3, 4) }

    it "assigns the data parameter" do
      header.data.should == 1
    end

    it "assigns the packet type parameter" do
      header.packet_type.should == 2
    end

    it "assigns the car parameter" do
      header.car.should == 3
    end

    it "assigns the event type parameter" do
      header.event_type.should == 4
    end
  end

  describe "(instance_methods)" do
    let(:data) { 1 }
    let(:packet_type) { 2 }
    let(:car) { 0 }
    let(:instance) { described_class.new(data, packet_type, car) }

    describe "#car?" do
      it "is false when the car number is zero" do
        described_class.new(data, packet_type, 0).car?.should == false
      end

      it "is true when the car number is nonzero" do
        described_class.new(data, packet_type, 10).car?.should == true
      end
    end

    describe "#packet_klass" do
      context "for system packets" do
        it "returns the class described by the header" do
          described_class.new(data, 0, 0).packet_klass.should == LiveF1::Packet::Unknown
          described_class.new(data, 1, 0).packet_klass.should == LiveF1::Packet::Sys::SessionStart
          described_class.new(data, 2, 0).packet_klass.should == LiveF1::Packet::Sys::KeyFrame
          described_class.new(data, 3, 0).packet_klass.should == LiveF1::Packet::Unknown
          described_class.new(data, 4, 0).packet_klass.should == LiveF1::Packet::Sys::Commentary
          described_class.new(data, 5, 0).packet_klass.should == LiveF1::Packet::Unknown
          described_class.new(data, 6, 0).packet_klass.should == LiveF1::Packet::Sys::Notice
          described_class.new(data, 7, 0).packet_klass.should == LiveF1::Packet::Sys::Timestamp
          # described_class.new(data, 8, 0).packet_klass.should == LiveF1::Packet::Unknown
          described_class.new(data, 9, 0).packet_klass.should == LiveF1::Packet::Sys::Weather
          described_class.new(data, 10, 0).packet_klass.should == LiveF1::Packet::Sys::Speed
          described_class.new(data, 11, 0).packet_klass.should == LiveF1::Packet::Sys::TrackStatus
          described_class.new(data, 12, 0).packet_klass.should == LiveF1::Packet::Sys::Copyright
          # described_class.new(data, 13, 0).packet_klass.should == LiveF1::Packet::Unknown
          # described_class.new(data, 14, 0).packet_klass.should == LiveF1::Packet::Unknown
          # described_class.new(data, 15, 0).packet_klass.should == LiveF1::Packet::Unknown
        end
      end

      context "for car packets" do
        it "raises an error if no event type is available" do
          lambda { described_class.new(data, 0, 1).packet_klass }.should raise_error
        end

        it "returns the class described by the header" do
          described_class.new(data, 0, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::PositionUpdate
          described_class.new(data, 1, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Position
          described_class.new(data, 2, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Number
          described_class.new(data, 3, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Driver
          described_class.new(data, 4, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Gap
          described_class.new(data, 5, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Interval
          described_class.new(data, 6, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::LapTime
          described_class.new(data, 7, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Sector1
          described_class.new(data, 8, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::PitLap1
          described_class.new(data, 9, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Sector2
          described_class.new(data, 10, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::PitLap2
          described_class.new(data, 11, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::Sector3
          described_class.new(data, 12, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::PitLap3

          described_class.new(data, 0, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::PositionUpdate
          described_class.new(data, 1, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Position
          described_class.new(data, 2, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Number
          described_class.new(data, 3, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Driver
          described_class.new(data, 4, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::BestLapTime
          described_class.new(data, 5, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Gap
          described_class.new(data, 6, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Sector1
          described_class.new(data, 7, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Sector2
          described_class.new(data, 8, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::Sector3
          described_class.new(data, 9, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::LapCount

          described_class.new(data, 0, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::PositionUpdate
          described_class.new(data, 1, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Position
          described_class.new(data, 2, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Number
          described_class.new(data, 3, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Driver
          described_class.new(data, 4, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Period1
          described_class.new(data, 5, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Period2
          described_class.new(data, 6, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Period3
          described_class.new(data, 7, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Sector1
          described_class.new(data, 8, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Sector2
          described_class.new(data, 9, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::Sector3

          pending "remaining packets" do
            described_class.new(data, 13, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::NumPits
            described_class.new(data, 15, 1, LiveF1::Event::RACE).packet_klass.should == LiveF1::Packet::Car::PositionHistory

            described_class.new(data, 15, 1, LiveF1::Event::PRACTICE).packet_klass.should == LiveF1::Packet::Car::PositionHistory

            described_class.new(data, 10, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::LapCount
            described_class.new(data, 15, 1, LiveF1::Event::QUALIFYING).packet_klass.should == LiveF1::Packet::Car::PositionHistory
          end
        end
      end

      it "raises an exception for an unexpected packet" do
        expect { described_class.new(data, 16, car).packet_klass }.to raise_error(LiveF1::Packet::Header::UnexpectedPacket)
      end
    end
  end
end
