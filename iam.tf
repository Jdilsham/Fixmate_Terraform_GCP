

module "service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~>4.0"

  project_id = var.project_id
  names      = ["fixmate-gke-sa"]
}

module "ci_service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~>4.0"

  project_id = var.project_id
  names      = ["fixmate-ci"]
}

module "ci_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~>8.2"

  projects = var.project_id

  bindings = {
    "roles/artifactregistry.writer" = [
      "serviceAccount:fixmate-ci@${var.project_id}.iam.gserviceaccount.com"
    ]

    "roles/container.developer" = [
      "serviceAccount:fixmate-ci@${var.project_id}.iam.gserviceaccount.com"
    ]

    "roles/container.clusterViewer" = [
      "serviceAccount:fixmate-ci@${var.project_id}.iam.gserviceaccount.com"
    ]

    "roles/iam.serviceAccountUser" = [
      "serviceAccount:fixmate-ci@${var.project_id}.iam.gserviceaccount.com"
    ]
  }
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


