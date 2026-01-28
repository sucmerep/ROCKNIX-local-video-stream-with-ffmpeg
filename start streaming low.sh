#!/bin/sh
PID=/tmp/ffmpeg_stream.pid
FFMPEG_DIR="/storage/ffmpeg"   # Pfad zu deinem ffmpeg Ordner

# Läuft schon?
if [ -f "$PID" ] && kill -0 "$(cat "$PID")" 2>/dev/null; then
  exit 0
fi

cd "$FFMPEG_DIR" || exit 1

CMD='./ffmpeg -init_hw_device drm=drm:/dev/dri/card0 -filter_hw_device drm \
  -f kmsgrab -framerate 30 -plane_id 45 -i - \
  -vf "hwmap=derive_device=vulkan,format=vulkan,hwdownload,format=bgr0,\
transpose=2,transpose=2,transpose=2,format=yuv420p,\
scale=640:360:sws_flags=fast_bilinear" \
  -c:v libx264 -preset ultrafast -crf 34 -pix_fmt yuv420p \
  -tune zerolatency -g 60 \
  -x264-params "scenecut=0:rc-lookahead=0:ref=1:bframes=0:aq-mode=0:vbv-maxrate=900:vbv-bufsize=1800" \
  -f mpegts "udp://192.168.178.255:1234?broadcast=1&pkt_size=1316&ttl=1"'

nohup sh -c "exec $CMD" </dev/null >/dev/null 2>&1 &
echo $! > "$PID"

exit 0
