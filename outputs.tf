output "vpc_name" {
  value = module.vpc.network_name
}

output "gke_cluster_name" {
  value = module.gke.name
}

output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/fixmate-repo"
}

output "cloudsql_instance_name" {
  value = google_sql_database_instance.fixmate.name
}

output "ci_service_account" {
  value = "fixmate-ci@${var.project_id}.iam.gserviceaccount.com"
}
