
data "aws_ami" "ubuntu_trusty" {
  most_recent = true
  filter {
    name = "name"                
    values = [ "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*" ]
  }
  owners = [ "099720109477" ] # Canonical
}

data "aws_ami" "ubuntu_xenial" {
  most_recent = true
  filter {
    name = "name"                
    values = [ "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*" ]
  }
  owners = [ "099720109477" ] # Canonical
}

data "aws_ami" "devops_ubuntu_trusty" {
  most_recent = true
  filter {
    name = "name"                
    values = [ "devops-ubuntu-14-04-x64*" ]
  }
  owners = [ "self" ] 
}


data "aws_ami" "devops_ubuntu_xenial" {
  most_recent = true
  filter {
    name = "name"                
    values = [ "devops-ubuntu-16-04-x64*" ]
  }
  owners = [ "self" ] 
}

data "aws_ami" "devops_oel7" {
  most_recent = true
  filter {
    name = "name"
    values = [ "devops-ol7*" ]
  }
  owners = [ "self" ]
}

#
# data "aws_ami" "devops_windows" {
#   most_recent = true
#   filter {
#      name = "name"                
#      values = [ "devops-windows-2012.R2-x64*" ]
#    }
#    owners = [ "self" ] 
#  }
# 
