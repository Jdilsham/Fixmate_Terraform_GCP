output "vpc_name" {
  value = module.vpc.network_name
}

output "gke_cluster_name" {
  value = google_container_cluster.gke.name
}

output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/fixmate-repo"
}

output "cloudsql_instance_name" {
  value = google_sql_database_instance.fixmate.name
}

output "service_account" {
  value = module.service_account.emails[0]
}


