ffmpeg \
  -vsync 0 \
  -hwaccel cuvid -c:v h264_cuvid \
  -i https://twitch-event-engineering-public.s3.amazonaws.com/sync-footage/Sync-Footage-V1-H264.mp4 \
  -c:v h264_nvenc -y output.mp4