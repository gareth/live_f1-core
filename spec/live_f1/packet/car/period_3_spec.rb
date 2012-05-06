require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Car::Period3 do
  it_behaves_like LiveF1::Packet::Type::Short
  it_behaves_like LiveF1::Packet::Decryptable
  it_behaves_like LiveF1::Packet::SectorTime

  subject { packet }
  
  let(:source) { mock(:source) }
  let(:header) { mock(:header) }
  let(:data)   { "" }
  let(:packet) do
    packet = described_class.new(source, header)
    packet.send :set_data, data
    packet
  end
end
