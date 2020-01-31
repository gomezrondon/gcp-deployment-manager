variable "project" {
  default = "ut-265822"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "machine_type" {
  type = "map"
  default = {
    dev = "f1-micro"
    prod = "n1-standard-1"
  }
}

variable "image" {
  default = "debian-cloud/debian-9"
}

variable "name_count" {
  default = ["server1","server2","server3"]
}

