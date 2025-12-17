module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~>13.0"

  project_id   = var.project_id
  network_name = "fixmate-vpc"

  subnets = [
    {
      subnet_name           = "fixmate-subnet"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = var.region
      subnet_private_access = true
      description           = "Subnet for Fixmate application"

      subnet_labels = {
        app = "fixmate"
        env = "dev"
      }
    }
  ]

  secondary_ranges = {
    "fixmate-subnet" = [
      {
        range_name    = "pods"
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = "services"
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }

}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~>33.0"

  project_id = var.project_id
  name       = "fixmate-gke-cluster"
  region     = var.region
  zones      = var.zones

  network    = module.vpc.network_name
  subnetwork = module.vpc.subnets_names[0]

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_range_pods     = "pods"
  ip_range_services = "services"

  node_pools = [
    {
      name           = "fixmate-node-pool"
      machine_type   = "e2-medium"
      node_locations = var.zones

      min_count = 1
      max_count = 2

      disk_size_gb = 20

      autoscaling = true

      tags = ["fixmate-gke-node"]

      labels = {
        env = "dev"
        app = "fixmate"
      }

      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
    }
  ]
}

module "service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~>4.0"

  project_id = var.project_id
  names      = ["fixmate-gke-sa"]
}

module "project_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 8.2"

  projects = var.project_id

  bindings = {
    "roles/cloudsql.client" = [
      "serviceAccount:fixmate-gke-sa@${var.project_id}.iam.gserviceaccount.com"
    ]

    "roles/artifactregistry.reader" = [
      "serviceAccount:fixmate-gke-sa@${var.project_id}.iam.gserviceaccount.com"
    ]

    "roles/logging.logWriter" = [
      "serviceAccount:fixmate-gke-sa@${var.project_id}.iam.gserviceaccount.com"
    ]

    "roles/monitoring.metricWriter" = [
      "serviceAccount:fixmate-gke-sa@${var.project_id}.iam.gserviceaccount.com"
    ]
  }
}

resource "google_artifact_registry_repository" "docker" {
  project       = var.project_id
  location      = var.region
  repository_id = "fixmate-repo"
  format        = "DOCKER"
}


