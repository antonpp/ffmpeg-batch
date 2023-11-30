#!/bin/sh

curl -sS -o input https://public.seenthis.co/gcp/rawfile.y4m

RC_PERF_MARK_PERFORMANCE_START=$(date +%s.%3N) &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 2000k -pass 1 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 /dev/null &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 2000k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 2000.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 1800k -maxrate 1801k -bufsize 1801k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 1800.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 1600k -maxrate 1601k -bufsize 1601k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 1600.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 1200k -maxrate 1201k -bufsize 1201k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 1200.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 1000k -maxrate 1001k -bufsize 1001k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 1000.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 800k -maxrate 801k -bufsize 801k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 800.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 600k -maxrate 601k -bufsize 601k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 600.mp4 &&
./ffmpeg -hwaccel cuda -hwaccel_output_format cuda -loglevel info -y -i input -b:v 300k -maxrate 301k -bufsize 301k -pass 2 -movflags +faststart -c:v av1_nvenc -preset 6 -f mp4 300.mp4 &&
RC_PERF_MARK_PERFORMANCE_STOP=$(date +%s.%3N) &&
RC_PERF_MARK_PERFORMANCE_DURATION=$(echo "scale=3; $RC_PERF_MARK_PERFORMANCE_STOP - $RC_PERF_MARK_PERFORMANCE_START" | bc) &&
echo "ffmpeg_benchmark:av1_nvencvp9:ffmpeg6-gkeap:$RC_PERF_MARK_PERFORMANCE_DURATION"