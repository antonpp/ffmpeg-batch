# ffmpeg-batch
GKE standard cluster with a GPU node (nvidia-l4) with a sample ffmpeg script that uses hardware acceleration.


```bash
terraform init
terraform apply
# run the gke_cluster_kubectl_command command to configure kubectl
cd scripts
sh apply_cfgmap.sh # will create a ConfigMap containing the scripts in scripts/bench_scripts
kubectl apply -f gpu_hello_job.yaml # this will run a sample ffmpeg command with hwaccel
```