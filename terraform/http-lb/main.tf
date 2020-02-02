# https://codelabs.developers.google.com/codelabs/cloud-load-balancers/index.html?index=..%2F..index#4
# Instance Template <- Describe Instance
resource "google_compute_instance_template" "instance_template" {
  name = "udemy-nginx-template"
  description = "This is our autoscaling template"
  tags = ["allow-http"] # network tag

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

  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello from Terraform on Google Cloud!</h1></body></html>' | sudo tee /var/www/html/index.html"

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


# Group Manager < -- Manages the nodes
resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name = "instance-nginx-group"
  base_instance_name = "instance-nginx"
  region = var.region

  version {
    name = "v1-ig"
    instance_template = google_compute_instance_template.instance_template.self_link
  }

  //target_pools = [google_compute_target_pool.default.self_link]
  target_size = 2

  named_port { // 7
    name = "http"
    port = 80
  }
}

resource "google_compute_firewall" "allow_http" {
  name = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-http"]
}

// 6
resource "google_compute_health_check" "default" {
  name = "udemy-http-basic-check"

  tcp_health_check {
    port = "80"
  }
}


//8
#https://www.terraform.io/docs/providers/google/r/compute_backend_service.html
resource "google_compute_backend_service" "default" {
  name     = "udemy-backend"
  protocol = "HTTP"

  health_checks = [google_compute_health_check.default.self_link]

  backend {// 9
    group = google_compute_region_instance_group_manager.instance_group_manager.instance_group
  }

}

// 10
resource "google_compute_url_map" "url-map" {
  name            = "udemy-web-map"
  default_service = google_compute_backend_service.default.self_link
}

// 11
resource "google_compute_target_http_proxy" "http-proxy" {
  name        = "udemy-http-lb-proxy"
  description = "http proxy for cadence graphite"
  url_map     = google_compute_url_map.url-map.self_link
}

// 12
// https://www.terraform.io/docs/providers/google/r/compute_global_forwarding_rule.html
resource "google_compute_global_forwarding_rule" "default" {
  name       = "udemy-http-content-rule"
  port_range = "80"
  target = google_compute_target_http_proxy.http-proxy.self_link
}