module "gke" {

  depends_on = [
    google_project_service.services
  ]

  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~>33.0"

  project_id = var.project_id
  name       = "fixmate-gke-cluster"
  region     = var.region
  zones      = var.zones

  network    = module.vpc.network_name
  subnetwork = module.vpc.subnets_names[0]

  remove_default_node_pool = true

  ip_range_pods     = "pods"
  ip_range_services = "services"

  node_pools = [
    {
      name           = "fixmate-node-pool"
      machine_type   = "e2-medium"
      node_locations = var.zones

      service_account = "fixmate-gke-sa@${var.project_id}.iam.gserviceaccount.com"

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