#!/bin/bash

# note that all options concerning input must occur before '-i /dev/video' to be effective and reduce encoding overhead
# second note: i temporarily had these settings enabled (-b:v 800k `# bitrate shouldn't be too high` -crf 21 `# default should be 23, higher value means lower quality`) -> turned out this drove cpu usage very high, while not specifying bitrate and crf brought similar results in terms of quality
ffmpeg -f v4l2 `# use v4l2 driver` \
	-s 960x720 `# reduce resolution a little` \
	-r 30 `# fix fps at 30` \
	-i /dev/video0 `# use default camera` \
	-preset ultrafast `# most important: reduce cpu impact` \
	-codec:v libx264 `# use H.264 encoding` \
	-movflags +faststart `# recommended for web streaming` \
	-f flv `# output Flash Video` \
        -an `# no audio` \
	rtmp://localhost/live/pi-stream
