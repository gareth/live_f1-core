require_relative 'live_f1/source'
require_relative 'live_f1/debug'

# =Formula 1 live timing
#
# The LiveF1 library allows realtime parsing of data from the F1 live
# timing stream. It connects to the binary stream and turns it into a series of
# objects describing the stream
#
# ==Basics
#
# The live timing service is primarily used to control the live timing Java
# applet at http://www.formula1.com/live_timing. However, the richness
# of the data it provides means that the stream could be used to provide a much
# deeper view of a session than the applet itself provides. This library
# provides the very basic toolkit allowing such an application to be built using
# Ruby, but when using it it's important to remember the service was built
# around this one visual use.
#
# The stream generates packets from the start of every practice, qualifying and
# race session. However anyone connecting to the stream after the start of a
# session doesn't get sent the entire packet history. Instead, keyframes
# containing the current live timing state are regularly generated throughout a
# session, and new connections are given the latest keyframe followed by the
# packets generated since that keyframe.
#
# ==Usage
#
# See bin/live-f1 for usage examples
#
module LiveF1
end
