resource "google_compute_instance" "default" {
  count = 1
  name = "list-${var.name_count[count.index]}"
  machine_type = var.machine_type["dev"]
  zone         = var.zone
  can_ip_forward = false
  description = "This is our virtual machine"

  tags = ["allow-http","allow-https"] # Firewall tags

  boot_disk {
    initialize_params {
      image = var.image
      size = 10
    }
  }

  labels = {
    l_name = "list-${var.name_count[count.index]}"
    l_machine_type = var.machine_type["dev"]
  }

  network_interface {
    network = "default"

  }

  metadata = {
    size = "10"
    foo = "bar"
  }

  metadata_startup_script = "echo Hi > test.txt"

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