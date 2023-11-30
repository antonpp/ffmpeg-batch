terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.7.0"
    }
  }
}

provider "google" {
  #credentials = file("<NAME>.json")
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc" {
  name = "ffmpeg-gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "ffmpeg-gke-subnet"
  region        = var.subnet_region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"
}


# Cloud Router is required for Cloud NAT
resource "google_compute_router" "router" {
  name    = "ffmpeg-gke-router"
  region  = var.subnet_region
  network = google_compute_network.vpc.name
}

# Cloud NAT configuration
resource "google_compute_router_nat" "nat" {
  name                               = "ffmpeg-gke-nat"
  router                             = google_compute_router.router.name
  region                             = var.subnet_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_container_cluster" "primary" {
  name     = "ffmpeg-gke-cluster"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    # Use an empty block to enable VPC-native traffic routing
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnetwork.name
}

resource "google_service_account" "nodes-sa" {
  account_id = "ffmpeg-gke-sa"
  display_name = "ffmpeg gke nodes sa"
}

resource "google_project_iam_binding" "storage_admin" {
  project = var.project
  role    = "roles/storage.admin"
  members = ["serviceAccount:${google_service_account.nodes-sa.email}"]
}

resource "google_project_iam_binding" "log_writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  members = ["serviceAccount:${google_service_account.nodes-sa.email}"]
}

resource "google_project_iam_binding" "metric_writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  members = ["serviceAccount:${google_service_account.nodes-sa.email}"]
}

resource "google_project_iam_binding" "resource_metadata_writer" {
  project = var.project
  role    = "roles/stackdriver.resourceMetadata.writer"
  members = ["serviceAccount:${google_service_account.nodes-sa.email}"]
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "ffmpeg-cpu-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  location = var.zone

  node_config {
    machine_type = "n2-standard-4"
    service_account = google_service_account.nodes-sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "gpu_pool" {
  name       = "ffmpeg-gpu-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  location = var.zone

  node_config {
    machine_type = "g2-standard-4"
    service_account = google_service_account.nodes-sa.email

    guest_accelerator {
      type  = "nvidia-l4"
      count = 1
      gpu_driver_installation_config {
        gpu_driver_version = "LATEST"
      }
    }

    image_type   = "cos_containerd"
    disk_size_gb = "100"
    disk_type    = "pd-balanced"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append" 
    ]
  }
}

output "gke_cluster_kubectl_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${google_container_cluster.primary.location} --project ${var.project}"
  description = "Run this command to configure kubectl to connect to the GKE cluster"
}