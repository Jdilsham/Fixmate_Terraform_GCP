resource "google_sql_database_instance" "fixmate" {
  name             = "fixmate-postgres"
  region           = var.region
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = module.vpc.network_self_link
    }
  }
}

resource "google_sql_database" "db" {
  name     = "fixmate"
  instance = google_sql_database_instance.fixmate.name
}

resource "google_sql_user" "user" {
  name     = "fixmate_user"
  instance = google_sql_database_instance.fixmate.name
  password = var.db_password
}
