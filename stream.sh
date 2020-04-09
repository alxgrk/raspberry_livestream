#!/bin/bash

# note that all options concerning input must occur before '-i /dev/video' to be effective and reduce encoding overhead
ffmpeg -f v4l2 `# use v4l2 driver` \
	-s 960x720 `# reduce resolution a little` \
	-r 30 `# fix fps at 30` \
	-i /dev/video0 `# use default camera` \
	-preset ultrafast `# most important: reduce cpu impact` \
	-b:v 2M `# increase bitrate for better quality` \
	-codec:v libx264 `# use H.264 encoding` \
	-movflags +faststart `# recommended for web streaming` \
	-f flv `# output Flash Video` \
        -an `# no audio` \
	rtmp://localhost/live/pi-stream
