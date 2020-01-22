resource "google_storage_bucket" "bucket" {
  count = 1
  name = "udemy-test-${count.index}"
  location = var.location
  storage_class = "REGIONAL"

  labels = {
    name = "udemy-test-${count.index}"
    location = var.location
  }

  versioning {
    enabled = true
  }

}

