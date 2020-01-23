resource "google_storage_bucket" "bucket" {
  name = var.bucket_name
  location = var.location
  storage_class = "REGIONAL"

  labels = {
    name = var.bucket_name
    location = var.location
  }

  versioning {
    enabled = true
  }

}

