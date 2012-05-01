require 'live_f1/packet'
require 'spec_helper'

extend PacketTypeExamples

describe LiveF1::Packet::Sys::Copyright do
  it_behaves_like LiveF1::Packet::Type::Long

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
