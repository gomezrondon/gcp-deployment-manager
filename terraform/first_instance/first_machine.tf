
// CONDITION ? true : false

variable "env" {default = "production"}

resource "google_compute_instance" "default" {
  count = 1
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