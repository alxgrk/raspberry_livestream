#!/bin/bash

set -x

while getopts ":a:n:" opt; do
  case $opt in
    a) PI_ADDRESS="$OPTARG"
    ;;
    n) STREAM_NAME="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [[ -z $PI_ADDRESS || -z $STREAM_NAME ]]; then
	echo "Please set '-a' for the Pi's address and '-n' for the stream's name"
	exit 1
fi

echo "Going to stream as '$STREAM_NAME' from '$PI_ADDRESS'"

cat <<EOF > stream.sh
#! /bin/bash

# Run avconv to stream the webcam's video to the RTMP server.

avconv  -f video4linux2 \       # Webcam format goes in 
        -s 320x176 \            # Small is big enough
        -r "10" \               # Fixed framerate at 10fps, somehow this needs to be a string
        -b 256k \               # Fixed bitrate
        -i /dev/video0 \        # Webcam device
        -vcodec libx264 \       # h264.1 video encoder
        -preset ultrafast \     # Use the fastest encoding preset
        -f flv \                # Flash video goes out
        -an \                   # No audio!
        'rtmp://$PI_ADDRESS/live/$STREAM_NAME'
EOF

sudo cp nginx.conf /usr/local/nginx/conf/nginx.conf
#cp stream.supervisor.conf /etc/supervisor/conf.d/stream.supervisor.conf
