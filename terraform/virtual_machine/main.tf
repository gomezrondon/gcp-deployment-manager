
locals {
  description = "instance of type ${var.machine_type["dev"]}}"
}

resource "google_compute_instance" "default" {
  count = var.instance_count
  name = "list-${var.name_count[count.index]}"
  machine_type = var.machine_type["dev"]
  zone         = var.zone
  can_ip_forward = false
  description = local.description

  tags = ["allow-http","allow-https","allow-ssh"] # Firewall tags

  boot_disk {
    initialize_params {
      image = var.image["ubuntu"]
      size = 10
    }
  }

  labels = {
    l_name = "list-${var.name_count[count.index]}"
    l_machine_type = var.machine_type["dev"]
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    size = "10"
    foo = "bar"
    ssh-keys = "INSERT_USERNAME:${file("~/ssh-key/my-keys.pub")}"
  }

# https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform
  provisioner "remote-exec" {
    connection {
      host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
      type        = "ssh"
      user        = "INSERT_USERNAME"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "echo '<!doctype html><html><body><h1>Hello from Terraform on Google Cloud!</h1></body></html>' | sudo tee /var/www/html/index.html",
      "touch /tmp/javier.txt"
    ]

  }

  service_account {
    scopes = ["userinfo-email", "compute-ro","storage-ro"]
  }


}



resource "google_compute_disk" "default" {
  name = "test-desk"
  type = "pd-standard" //https://cloud.google.com/compute/docs/disks/add-persistent-disk#create_disk
  zone = var.zone
  size = 10
}

resource "google_compute_attached_disk" "default" {
  disk = google_compute_disk.default.self_link
  instance = google_compute_instance.default[0].self_link
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