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

ffmpeg -f v4l2 `# use v4l2 driver` \
	-i /dev/video0 `# use default camera` \
	-preset ultrafast `# we need to be ultrafast` \
	-b:v 1024k -s 960x720 `# drop bitrate a little in order to still get good fps higher resolution` \
	-codec:v libx264 `# use H.264 encoding` \
	-f flv `# output Flash Video` \
	-an `# no audio` \
	rtmp://$PI_ADDRESS/live/$STREAM_NAME

EOF
chmod +x stream.sh

sudo cp nginx.conf /usr/local/openresty/nginx/conf/
sudo cp auth.html /usr/local/openresty/nginx/
