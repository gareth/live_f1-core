module LiveF1
  class Packet
    class Sys
      class Commentary < Sys
        include Packet::Type::Long
        include Packet::Decryptable
        
				# Is this the last line of this commentary string?
				#
				# If not, the next packet should also be a Commentary packet continuing this text
				def terminal?
					data.bytes.to_a[1] == 1
				end

				# Returns the line of commentary, which may only be a partial line if
				# this commentary was split over multiple packets
				def line
					# The commentary packet encoding is all messed up. Its UTF-8 characters
					# have been treated as Windows-1252 and then reconverted back to UTF-8.
					# This is where we try and undo that.
					data[2..-1].force_encoding("UTF-8").encode("Windows-1252").force_encoding("UTF-8")
				end
      end
    end
  end
end
