#!/bin/sh

curl -sS -o input https://public.seenthis.co/gcp/rawfile.y4m

RC_PERF_MARK_PERFORMANCE_START=$(date +%s.%3N) &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 2000k -pass 1 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 /dev/null &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 2000k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 2000.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 1800k -maxrate 1800k -bufsize 1800k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 1800.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 1600k -maxrate 1600k -bufsize 1600k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 1600.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 1200k -maxrate 1200k -bufsize 1200k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 1200.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 1000k -maxrate 1000k -bufsize 1000k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 1000.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 800k -maxrate 800k -bufsize 800k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 800.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 600k -maxrate 600k -bufsize 600k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 600.mp4 &&
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel panic -y -i input.y4m -b:v 300k -maxrate 300k -bufsize 300k -pass 2 -movflags +faststart -c:v hevc_nvenc -tag:v hvc1 -f mp4 300.mp4 &&
RC_PERF_MARK_PERFORMANCE_STOP=$(date +%s.%3N) &&
RC_PERF_MARK_PERFORMANCE_DURATION=$(echo "scale=3; $RC_PERF_MARK_PERFORMANCE_STOP - $RC_PERF_MARK_PERFORMANCE_START" | bc) &&
echo "PERFORMANCE_DURATION_h265_HWA:$RC_PERF_MARK_PERFORMANCE_DURATION:END_PERFORMANCE_DURATION_h265_HWA"