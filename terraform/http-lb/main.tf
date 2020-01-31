# https://codelabs.developers.google.com/codelabs/cloud-load-balancers/index.html?index=..%2F..index#4
# Instance Template <- Describe Instance
resource "google_compute_instance_template" "instance_template" {
  name = "udemy-nginx-template"
  description = "This is our autoscaling template"
  tags = ["allow-http"] # network

  instance_description = "This is an instance that has been auto scaled"
  machine_type = var.machine_type["prod"]

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1604-lts"
    auto_delete = true
    boot = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y nginx && sudo service nginx start"

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"]
  }

}


resource "google_compute_firewall" "allow-http" {
  name    = "terra-allow-http"
  network = "default"
  target_tags = ["allow-http"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

resource "google_compute_target_pool" "default" {
  name = "udemy-instance-pool"
  region = var.region
}


# Group Manager < -- Manages the nodes
resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name = "instance-nginx-group"
  base_instance_name = "instance-nginx"
  region = var.region

  version {
    name = "v1-ig"
    instance_template = google_compute_instance_template.instance_template.self_link
  }

  target_pools = [google_compute_target_pool.default.self_link]
  target_size = 2
}

