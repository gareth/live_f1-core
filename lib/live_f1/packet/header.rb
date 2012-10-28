require_relative '../packet'
require_relative '../event'

module LiveF1
  class Packet
    # The Unknown packet is a special placeholder packet for situations where a
    # zero-length packet is delivered but seems to have no effect on the stream
    class Unknown < Packet
      include Packet::Type::Special

      def to_s
        "Unknown packet type #{header.packet_type}" + (header.car > 0 ? " for car #{header.car}" : "")
      end
    end

    # A Header uses 2 bytes of data from a live timing stream to determine all
    # the necessary information about the packet which follows it.
    class Header < Struct.new(:data, :packet_type, :car, :event_type)
      attr_reader :bytes

      def self.from_source source, event_type
        bytes = source.read_bytes(2)
        raise MissingData, "No data from #{source.inspect}" unless bytes.to_s.length == 2
        bits = bytes.to_s.reverse.unpack("B*").first
        _, data, packet_type, car = bits.match(/^(.{7})(.{4})(.{5})$/).to_a.map { |s| s.to_i(2) }

        new(data, packet_type, car, event_type).tap do |header|
          # TODO: Maybe need a nicer way of setting this
          header.instance_variable_set "@bytes", bytes
        end
      end

      def car?
        !car.zero?
      end

      def packet_klass
        case
        when car?
          case event_type
          when Event::RACE
            case packet_type
            when 0 then Packet::Car::PositionUpdate
            when 1 then Packet::Car::Position
            when 2 then Packet::Car::Number
            when 3 then Packet::Car::Driver
            when 4 then Packet::Car::Gap
            when 5 then Packet::Car::Interval
            when 6 then Packet::Car::LapTime
            when 7 then Packet::Car::Sector1
            when 8 then Packet::Car::PitLap1
            when 9 then Packet::Car::Sector2
            when 10 then Packet::Car::PitLap2
            when 11 then Packet::Car::Sector3
            when 12 then Packet::Car::PitLap3
            when 13 then Packet::Car::NumPits
            when 14 then nil
            when 15 then Packet::Car::PositionHistory
            end
          when Event::PRACTICE
            case packet_type
            when 0 then Packet::Car::PositionUpdate
            when 1 then Packet::Car::Position
            when 2 then Packet::Car::Number
            when 3 then Packet::Car::Driver
            when 4 then Packet::Car::BestLapTime
            when 5 then Packet::Car::Gap
            when 6 then Packet::Car::Sector1
            when 7 then Packet::Car::Sector2
            when 8 then Packet::Car::Sector3
            when 9 then Packet::Car::LapCount
            when 10 then Packet::Car::LapCount
            when 15 then nil
            end
          when Event::QUALIFYING
            case packet_type
            when 0 then Packet::Car::PositionUpdate
            when 1 then Packet::Car::Position
            when 2 then Packet::Car::Number
            when 3 then Packet::Car::Driver
            when 4 then Packet::Car::Period1
            when 5 then Packet::Car::Period2
            when 6 then Packet::Car::Period3
            when 7 then Packet::Car::Sector1
            when 8 then Packet::Car::Sector2
            when 9 then Packet::Car::Sector3
            when 10 then Packet::Car::LapCount
            when 15 then nil
            end
          else
            raise MissingEventType, "Unrecognised event type (#{event_type.inspect}), can't determine class for car packet #{packet_type.inspect}"
          end
        else
          case packet_type
          when 0 then Packet::Unknown
          when 1 then Packet::Sys::SessionStart
          when 2 then Packet::Sys::KeyFrame
          when 3 then Packet::Unknown
          when 4 then Packet::Sys::Commentary
          when 5 then Packet::Unknown
          when 6 then Packet::Sys::Notice
          when 7 then Packet::Sys::Timestamp
          when 8 then nil # Packet::Unknown
          when 9 then Packet::Sys::Weather
          when 10 then Packet::Sys::Speed
          when 11 then Packet::Sys::TrackStatus
          when 12 then Packet::Sys::Copyright
          when 13 then nil # Packet::Unknown
          when 14 then nil # Packet::Unknown
          when 15 then nil # Packet::Unknown
          end
        end or raise UnexpectedPacket, "Unexpected #{car? ? 'car' : 'sys'} packet type #{packet_type.inspect} for #{Event::Type.name_for event_type} event"
      end

      class MissingEventType < RuntimeError
      end

      # An unexpected packet is one that we don't expect to appear in the data stream
      class UnexpectedPacket < RuntimeError
      end

      # An unknown packet is one that we expect (from experience) to appear in the data stream but don't know its purpose
      class UnknownPacket < RuntimeError
      end

      class MissingData < EOFError
      end
    end
  end
end
