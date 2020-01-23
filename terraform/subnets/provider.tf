// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("credentials_file.json")}"
  project     = var.project
  region      = var.region
}
