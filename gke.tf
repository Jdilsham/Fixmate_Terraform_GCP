resource "google_container_cluster" "gke" {
  name     = "fixmate-gke-cluster"
  location = var.region
  project  = var.project_id

  network    = module.vpc.network_name
  subnetwork = module.vpc.subnets_names[0]

  node_locations = var.zones

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  resource_labels = {
    app = "fixmate"
    env = "dev"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  depends_on = [
    google_project_service.services
  ]
}

resource "google_container_node_pool" "primary" {
  name     = "fixmate-node-pool"
  cluster  = google_container_cluster.gke.name
  location = var.region
  project  = var.project_id

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = "e2-medium"
    disk_size_gb    = 20
    service_account = "fixmate-gke-sa@${var.project_id}.iam.gserviceaccount.com"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    shielded_instance_config {
      enable_secure_boot = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      env = "dev"
      app = "fixmate"
    }

    tags = ["fixmate-gke-node"]
  }
}
