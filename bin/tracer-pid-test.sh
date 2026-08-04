#!/usr/bin/env bash
set -euo pipefail
strace -o /dev/null sleep 30 &
tracer=$!
trap 'kill "$tracer" 2>/dev/null || true' EXIT
target=""
for _ in $(seq 1 50); do
    target=$(pgrep -P "$tracer" sleep || true)
    [ -n "$target" ] && break
    sleep 0.1
done
[ -n "$target" ] || { echo "FAIL: could not find traced sleep" >&2; exit 1; }
tpid=$(awk '/^TracerPid:/ {print $2}' "/proc/$target/status")
echo "traced sleep pid: $target, strace pid: $tracer, TracerPid: $tpid"
if [ "$tpid" = "0" ]; then
    echo "OK: TracerPid hidden (patch active)"
else
    echo "FAIL: TracerPid=$tpid leaks tracer pid (patch inactive or not rebooted)" >&2
    exit 1
fi
