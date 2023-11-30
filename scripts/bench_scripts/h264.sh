#!/bin/sh

curl -sS -o input https://public.seenthis.co/gcp/rawfile.y4m

RC_PERF_MARK_PERFORMANCE_START=$(date +%s.%3N) &&
ffmpeg -loglevel panic -y -i input -b:v 2000k -pass 1 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium /dev/null &&
ffmpeg -loglevel panic -y -i input -b:v 2000k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 2000.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 1800k -maxrate 1800k -bufsize 1800k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 1800.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 1600k -maxrate 1600k -bufsize 1600k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 1600.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 1200k -maxrate 1200k -bufsize 1200k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 1200.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 1000k -maxrate 1000k -bufsize 1000k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 1000.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 800k -maxrate 800k -bufsize 800k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 800.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 600k -maxrate 600k -bufsize 600k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 600.mp4 &&
ffmpeg -loglevel panic -y -i input -b:v 300k -maxrate 300k -bufsize 300k -pass 2 -movflags +faststart -c:v libx264 -f mp4 -profile:v baseline -pix_fmt yuv420p -vsync 1 -x264opts no-scenecut -preset medium 300.mp4 &&
RC_PERF_MARK_PERFORMANCE_STOP=$(date +%s.%3N) &&
RC_PERF_MARK_PERFORMANCE_DURATION=$(echo "scale=3; $RC_PERF_MARK_PERFORMANCE_STOP - $RC_PERF_MARK_PERFORMANCE_START" | bc) &&
echo "ffmpeg_benchmark:libx264:ffmpeg6-ws:$RC_PERF_MARK_PERFORMANCE_DURATION"