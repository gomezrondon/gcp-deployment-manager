# creacion del instance template
resource "google_compute_instance_template" "instance_template" {
  name = "udemy-server-${count.index+1}}"
  description = "this is a template"
  #tags = [] #getworking
  labels ={
    enviroment = "production"
    name = "udemy-server-${count.index+1}}"
  }
  instance_description = "this is an isntance that has been auto scaled"
  machine_type = "f1-micro"
  can_ip_forward = false

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1604-lts"
    auto_delete = true
    boot = true
  }

  disk {
    auto_delete = false
    disk_size_gb = 10
    mode = "READ_WRITE"
    type = "PERSISTENT"
  }

  metadata {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email","compute-ro","storage-ro"]
  }

}

