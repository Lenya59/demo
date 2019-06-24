################################################################################
#hide creds from all of the world
variable "access_key" {}
variable "secret_key" {}

#string type
variable "ami" {
  type    = "string"
  default = "ami-098bb5d92c8886ca1"
}
variable "region" {
  type    = "string"
  default = "us-east-1"
}
variable "instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "amis_tags" { default = ["back", "service"] }

variable "cidr" {
  type = "map"
  default = {
    "main"     = "10.20.0.0/16"
    "front"    = "10.20.1.0/24"
    "back"     = "10.20.2.0/24"
    "services" = "10.20.3.0/24"
    "all"      = "0.0.0.0/0"

  }
}
