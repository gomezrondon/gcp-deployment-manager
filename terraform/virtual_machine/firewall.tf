resource "google_compute_firewall" "allow-ssh" {
  //https://www.terraform.io/docs/providers/google/r/compute_firewall.html
  name    = "allow-ssh"
  network = "default"
  priority = 500
  target_tags = ["allow-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
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


resource "google_compute_firewall" "allow_https" {
  name = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["443"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-https"]
}