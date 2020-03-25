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
#!/bin/bash

ffmpeg -f v4l2 `# system driver` \
       -i /dev/video0 `# camera device` \
       -preset ultrafast `# fastest encoding` \
       -vcodec libx264 `# h264.1 encoder` \
       -r 10 `# framerate in fps` \
       -b:v 256k `# bitrate` \
       -s 320x176 `# size: small` \
       -f flv `# output flash video` \
       -an `# no audio` \
       -loglevel warning `# don't spam` \
       "rtmp://$PI_ADDRESS/live/$STREAM_NAME" `# destination`

EOF
chmod +x stream.sh

cat <<EOF > livestream-supervisor.conf
; The minimal Supervisord configuration for running the live stream.
[program:serve]
command=$(pwd)/stream.sh
directory=$(pwd)
autostart=true
autorestart=true
user=pi

[program:nginx]
command=/usr/local/nginx/sbin/nginx
autostart=true
autorestart=true
user=root
EOF

sudo cp nginx.conf /usr/local/nginx/conf/nginx.conf
sudo cp livestream-supervisor.conf /etc/supervisor/conf.d/
