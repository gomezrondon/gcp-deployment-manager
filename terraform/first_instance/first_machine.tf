
// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  count = length(var.name_count)
  name = "list-${var.name_count[count.index]}"
  machine_type = var.machine_type["dev"]
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

  }

  service_account {
    scopes = ["userinfo-email", "compute-ro","storage-ro"]
  }

}

output "machine_type" {
  value = "${google_compute_instance.default.*.machine_type}"
}

output "machine_name" {
  value = "${google_compute_instance.default.*.name}"
}

output "machine_zone" {
  value = "${google_compute_instance.default.*.zone}"
}