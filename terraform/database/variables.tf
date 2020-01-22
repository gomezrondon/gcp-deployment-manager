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
  default = "debian-cloud/debian-9"
}

variable "name_count" {
  default = ["server1","server2","server3"]
}

//---------------db config
variable "tier" {default = "db-f1-micro"}
variable "name" {default = "gcpdatabase"}
variable "db_region" {default = "us-west1"}
variable "disk_size" {default = 20}
variable "db_version" {default = "MYSQL_5_7"}
variable "user_host" {default = "%"}
variable "user_name" {default = "admin"}
variable "user_password" {default = "123456"}
variable "replication_type" {default = "SYNCHRONOUS"}
variable "activation_policy" {default = "always"}