kubectl create cm ffmpeg-scripts --from-file=./bench_scripts/ --dry-run=client -o yaml | kubectl apply -f -