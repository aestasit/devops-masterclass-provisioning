variable "student_count" {
  default = "0"
}

variable "host_name" {
  default = "devops-server"
}

variable "main_server_disk_gb" {
  default = 60
}

variable "student_server_disk_gb" {
  default = 20
}

provider "aws" {
  region = "eu-west-1"
}

provider "cloudflare" {
  email = "andrey@aestasit.com"
  token = file("../secrets/cloudflare.token")
}

variable "cloudflare_zone" {
  default = "extremeautomation.io"
}

variable "dnsimple_domain" {
  default = "extremeautomation.io"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

variable "cluster-name" {
  default = "devops-cluster"
  type    = string
}

