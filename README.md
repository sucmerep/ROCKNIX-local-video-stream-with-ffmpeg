>Note: Audio is currently not working. 

**1. SSH into your ROCKNIX Device**

**2. Download ffmpeg to /storage/ffmpeg**

`mkdir -p /storage/ffmpeg
cd /storage/ffmpeg
wget https://github.com/descriptinc/ffmpeg-ffprobe-static/releases/download/b6.1.2-rc.1/ffmpeg-linux-arm64 -O ffmpeg
wget https://github.com/descriptinc/ffmpeg-ffprobe-static/releases/download/b6.1.2-rc.1/ffprobe-linux-arm64 -O ffprobe`

**You can take a screenshot by using the following SSH input:**

`cd /storage/ffmpeg`

`./ffmpeg -init_hw_device drm=drm:/dev/dri/card0 -filter_hw_device drm \
  -f kmsgrab -plane_id 45 -i - \
  -vf "hwmap=derive_device=vulkan,format=vulkan,hwdownload,format=bgr0,transpose=dir=clock" \
  -frames:v 1 -update 1 screenshot.png`

**You can record a video with the following SSH input:**

`cd /storage/ffmpeg`

`./ffmpeg -init_hw_device drm=drm:/dev/dri/card0 -filter_hw_device drm \
  -f kmsgrab -framerate 30 -plane_id 45 -i - \
  -vf "hwmap=derive_device=vulkan,format=vulkan,hwdownload,format=bgr0,transpose=2,transpose=2,transpose=2,format=yuv420p,scale=1280:720" \
  -c:v libx264 -preset ultrafast -crf 28 -pix_fmt yuv420p \
  -t 15 video_output.mp4`

**Videostream (might need to change IP to local network, keep .255 at the end):**

>The local network videostream can be played with VLC Media player

cd /storage/ffmpeg

`./ffmpeg -init_hw_device drm=drm:/dev/dri/card0 -filter_hw_device drm \
  -f kmsgrab -framerate 30 -plane_id 45 -i - \
  -vf "hwmap=derive_device=vulkan,format=vulkan,hwdownload,format=bgr0,transpose=2,transpose=2,transpose=2,format=yuv420p,scale=1280:720" \
  -c:v libx264 -preset ultrafast -crf 28 -pix_fmt yuv420p -tune zerolatency -g 60 \
  -f mpegts "udp://192.168.178.255:1234?broadcast=1&pkt_size=1316&ttl=1"`

**Faster, lower quality stream:**

`cd /storage/ffmpeg`

`./ffmpeg -init_hw_device drm=drm:/dev/dri/card0 -filter_hw_device drm \
  -f kmsgrab -framerate 30 -plane_id 45 -i - \
  -vf "hwmap=derive_device=vulkan,format=vulkan,hwdownload,format=bgr0,\
transpose=2,transpose=2,transpose=2,format=yuv420p,\
scale=640:360:sws_flags=fast_bilinear" \
  -c:v libx264 -preset ultrafast -crf 34 -pix_fmt yuv420p \
  -tune zerolatency -g 60 \
  -x264-params "scenecut=0:rc-lookahead=0:ref=1:bframes=0:aq-mode=0:vbv-maxrate=900:vbv-bufsize=1800" \
  -f mpegts "udp://192.168.178.255:1234?broadcast=1&pkt_size=1316&ttl=1"`


  
