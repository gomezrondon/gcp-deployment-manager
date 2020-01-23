variable "project" { 
    default = "clear-gantry-123"
}

variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-a"
}

variable "machine_type" {
  type = "map"
  default = {
    dev = "f1-micro"
    prod = "n1-standard-1"
  }
}

variable "image" {
  //https://cloud.google.com/compute/docs/images
  type = "map"
  default = {
    debian = "debian-cloud/debian-9"
    ubuntu = "ubuntu-os-cloud/ubuntu-1804-lts"
  }
}

variable "instance_count" {
  default = 1
}

variable "name_count" {
  default = ["server1","server2","server3"]
}