#!/bin/sh
PID=/tmp/ffmpeg_stream.pid

[ -f "$PID" ] || exit 0
FFPID="$(cat "$PID")"

if ! kill -0 "$FFPID" 2>/dev/null; then
  rm -f "$PID"
  exit 0
fi

kill "$FFPID" 2>/dev/null

for i in 1 2 3 4 5; do
  sleep 1
  kill -0 "$FFPID" 2>/dev/null || break
done

kill -0 "$FFPID" 2>/dev/null && kill -9 "$FFPID" 2>/dev/null

rm -f "$PID"
exit 0
