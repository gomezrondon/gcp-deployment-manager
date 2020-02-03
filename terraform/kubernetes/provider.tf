// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("credentials_file_ut.json")}"
  project     = var.project
  region      = var.region
}

