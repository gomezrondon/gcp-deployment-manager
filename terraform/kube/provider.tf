// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("credentials_file.json")}"
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = "${file("credentials_file.json")}"
  project     = var.project
  region      = var.region
}
