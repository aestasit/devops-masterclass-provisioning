
variable "student_count" {
  default = "5"
}

variable "admin_password" {
  default = "BGOMEUC8EP"
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

provider "dnsimple" {
  token    = "${file("../secrets/dnsimple.token")}"
  account  = "${file("../secrets/dnsimple.account.id")}"
}

variable "dnsimple_domain" {
  default  = "extremeautomation.io"
}

data "aws_availability_zones" "available" {

}
