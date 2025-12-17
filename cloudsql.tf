resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services-fixmate"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {

  depends_on = [
    google_compute_global_address.private_ip_range
  ]
  
  network                 = module.vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["google-managed-services-fixmate"]
}



resource "google_sql_database_instance" "fixmate" {

  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
  name                = "fixmate-postgres"
  region              = var.region
  database_version    = "POSTGRES_15"
  deletion_protection = false
  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = module.vpc.network_self_link
    }
  }
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.fixmate.name
}

resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.fixmate.name
  password = var.db_password
}
