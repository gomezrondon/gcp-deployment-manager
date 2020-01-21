
// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "clear-gantry-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

  }
/* esto no funciona
  service_account {
    scopes = ["userinfo-email", "compute-ro","storage-ro"]
  }
*/
}

