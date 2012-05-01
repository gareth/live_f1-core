require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Car::Position do
  it_behaves_like LiveF1::Packet::Type::Short
  it_behaves_like LiveF1::Packet::Decryptable

  subject { packet }
  
  let(:source) { mock(:source) }
  let(:header) { mock(:header) }
  let(:data)   { "" }
  let(:packet) do
    packet = described_class.new(source, header)
    packet.data = data
    packet
  end
end
