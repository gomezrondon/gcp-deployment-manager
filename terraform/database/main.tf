
resource "google_sql_database_instance" "gcp_database" {
  name = var.name
  region = var.db_region
  database_version = var.db_version
  settings {
    tier = var.tier
    disk_size = var.disk_size
    replication_type = var.replication_type
    activation_policy = var.activation_policy
  }
}

#https://www.terraform.io/docs/providers/google/r/sql_database.html
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.gcp_database.name
}

resource "google_sql_user" "admin" {
  count = 1
  name = var.user_name
  host = var.user_host
  password = var.user_password
  instance = google_sql_database_instance.gcp_database.name
}
