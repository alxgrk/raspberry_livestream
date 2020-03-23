# Streaming live video from a webcam over RTMP using a Raspberry Pi and Nginx

## Disclaimer

This fork uses the base repo as an inspiration. Maybe fundemental things will be changed here.

## Hardware

This is the hardware I used. You will probably have some other stuff... which should work as well.

- RaspberryPi B with Raspbian installed
- 16 GB SD card
- Waveshare Kamera (C), 5 MP Fixfokus
- 2A power adapter
- All these things connected appropriately

## Installing the necessary software

*see https://github.com/arut/nginx-rtmp-module/wiki/Getting-started-with-nginx-rtmp for more detailed information*

Everything here should be done on the Raspberry Pi (as opposed to on your computes) unless stated otherwise. 

### Basics

Some basic dependencies:

```bash
sudo apt-get install ffmpeg supervisor avconv build-essential libpcre3 libpcre3-dev libssl-dev git zlib1g-dev
```

### Build Nginx with RTMP module

To stream our video to the web we use [Nginx](http://nginx.org/) with an [RTMP module](https://github.com/arut/nginx-rtmp-module). This module has to be compiled into Nginx, but you can simply use `build.sh`.

### Install this repo's content

Do it by simply running `./install.sh -a <PI_ADDRESS> -n <STREAM_NAME>`

### Run the systems!

This will (re)start Nginx and the stream itself.

```bash
./start.sh
```

## Verify the stream

You can check that it's actually streaming by opening this URI in [VLC](http://www.videolan.org/vlc/index.html) on your computes:

```uri
rtmp://<RASPBERRY_IP/live/<STREAM_NAME> 
```

## Showing the stream on a web page

We used [HDW Player](http://www.hdwplayer.com) for showing the RTMP-stream, but there are probably many more.

Download it and put the `player` folder in a project folder somewhere.

Then to show the video you can do something like this (replace <THESE_THINGS>):

```html
<html>
  <head>
    <script src="<PROJECT_FOLDER>/player/hdwplayer.js"></script>
  </head>
  <body>
    <div id="player"></div>
    <script type="text/javascript">
      hdwplayer({ 
        id        : 'player',
        swf       : '<PROJECT_FOLDER>/player/player.swf',
        width     : '640',
        height    : '334',
        type      : 'rtmp',
        streamer  : 'rtmp://<RASPBERRY_IP/live',
        video     : '<STREAM_NAME>',
        autoStart : 'true',
        controlBar: 'false'
        });
    </script>
  </body>
</html>
```

That should do it! Go fot it!

## Adventures
As mentioned, we ran into a little bit of trouble before it worked. Hereby a short summary what we tried and why it did not work;

1. Stream to [bambuser.com](http://bambuser.com)

   We never got the stream connected  at Bamuser. The RMTP-addresses were unclear and did not accepted the connections.
  
2. Stream to [twitch.tv](http://twitch.tv)

   This did not worked as we got banned several times, because we were not streaming gaming content. Wierd! Foosball is the best sport ever.
   
3. Stream to [youtube.com](http://youtube.com)

   This attempt almost worked, we had a few cases were the stram was received. But in the end YouTube did not accepted the low bitrate coming from the RasberryPi.

## Credits

Built at [Rockstart](http://rockstart.com) by [Sjoerd Huisman](https://github.com/shuisman) from [Congressus](https://www.congressus.nl/) and [Tom Aizenberg](https://github.com/Tomtomgo) from [Achieved](http://achieved.co).
