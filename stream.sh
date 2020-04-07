#!/bin/bash

ffmpeg -f v4l2 `# use v4l2 driver` \
	-i /dev/video0 `# use default camera` \
	-b:v 1024k -s 960x720 `# drop bitrate a little in order to still get good fps at higher resolution` \
	-codec:v libx264 `# use H.264 encoding` \
	-f flv `# output Flash Video` \
        -an `# no audio` \
	rtmp://localhost/live/pi-stream
