// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("credentials_file.json")}"
  project     = var.project
  region      = var.region
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "clear-gantry-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "${google_compute_network.vpc_network.self_link}"

    access_config {
      // Include this section to give the VM an non ephemiral external ip address
    }
  }

  tags = ["open-ssh-tag"]

}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "allow-ssh" {
  //https://www.terraform.io/docs/providers/google/r/compute_firewall.html
  name    = "terra-allow-ssh"
  network = "${google_compute_network.vpc_network.self_link}"
  priority = 500
  target_tags = ["open-ssh-tag"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow-http" {
  name    = "terra-allow-http"
  network = "${google_compute_network.vpc_network.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

resource "google_storage_bucket" "image-store" {
  //https://www.terraform.io/docs/providers/google/r/storage_bucket.html
  name     = "image-store-bucket-test"
  location = "US"

}