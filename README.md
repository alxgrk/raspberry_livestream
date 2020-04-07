# Streaming live video from a webcam over RTMP using a Raspberry Pi, Nginx and Basic auth

## Disclaimer

This fork uses the base repo as an inspiration. Maybe fundamental things will be changed here.

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
sudo apt-get install certbot apache2-utils ffmpeg curl avconv perl make build-essential libpcre3 libpcre3-dev libssl-dev git zlib1g-dev
```

#### Basic Auth

Since I wanted at least a minimal level of security, I added Basic auth check on stream play. To generate users, you can simply use `createUsers.sh` like this:
```bash
./createUsers.sh user1 user2 user3 ...
```

#### HTTPS

The `nginx.conf` contains a virtual server for delivering content via HTTPS. Currently, this is not customizable, so if you want to remove it, you need to adapt the scripts.

### Build Nginx with RTMP module

To stream our video to the web we use [Nginx](http://nginx.org/) (to be honest: it's [OpenResty](https://openresty.org/en/)) with an [HTTP-FLV module](https://github.com/winshining/nginx-http-flv-module). This module has to be compiled into Nginx, which can be done by running:
```bash
./build.sh
```

### Install this repo's content

Do it by simply running: 
```bash
./install.sh -d <<YOUR_DOMAIN>>
```

### Run the systems!

This will (re)start Nginx and the stream itself:
```bash
./start.sh

# for the first run your need to call
./start.sh -d <<YOUR_DOMAIN>> -m <<YOUR_MAIL_ADDRESS>>
```

Since for my usecase I wanted to stop the nginx server easily, its runtime is bound to the `start.sh` script. Means: nginx gets stop when quitting the `start.sh` script.

## Verify the stream

You can check that it's actually streaming by opening this URI in [VLC](http://www.videolan.org/vlc/index.html) on your computes:

```uri
rtmp://localhost/live/pi-stream?basic_auth=<<BASIC_HASH>>
```

```uri
https://localhost/live?app=live&stream=pi-stream&basic_auth=<<BASIC_HASH>>
```

## Showing the stream on a web page

I put some little HTML and CSS in the `frontend/` folder, which is used at the root endpoint. It uses [flv.js](https://github.com/Bilibili/flv.js) to play the livestream. Have a look at [index.html](./frontend/index.html) concerning the library's usage.

## Credits

Originally built at [Rockstart](http://rockstart.com) by [Sjoerd Huisman](https://github.com/shuisman) from [Congressus](https://www.congressus.nl/) and [Tom Aizenberg](https://github.com/Tomtomgo) from [Achieved](http://achieved.co).
