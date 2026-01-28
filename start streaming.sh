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
  -vf "hwmap=derive_device=vulkan,format=vulkan,hwdownload,format=bgr0,transpose=2,transpose=2,transpose=2,format=yuv420p,scale=1280:720" \
  -c:v libx264 -preset ultrafast -crf 28 -pix_fmt yuv420p -tune zerolatency -g 60 \
  -f mpegts "udp://192.168.178.255:1234?broadcast=1&pkt_size=1316&ttl=1"'

nohup sh -c "exec $CMD" </dev/null >/dev/null 2>&1 &
echo $! > "$PID"

exit 0
