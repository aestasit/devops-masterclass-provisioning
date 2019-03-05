
resource "aws_key_pair" "devops_key" {
  key_name = "devops_key" 
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyVEewxjfAmcfOGuZ63TmgfEG0cAKawZjgQGAFQ9gSaa9rMPdSCRlUEAR6yjuSUwcKhHqiGzbtSpwPyuNBTDZ27F+gdrJXYlgKhNbtWBmlncZQLH1R8OWC/Mj9VDO2EohkM5mn7mVNFiw/RYdzYd9n3iNzVoHBRleF162dnzyosezoA7c8CqzlrySQ1VpqhxnyjJ9Em4IETmwXSg9wpLMlIvl5d/Xz5hu0LL7FhUM4BG1SVDjm53nUpiJyoG3foHdaCzlWwFD2e1uAIysbhfg8gjplBf1Px00jI9g6BzAdOQevfDp/R4othge7MiyVXIj+sxputaAZAFjnA/WRdjeB info@extremeautomation.io"
}

resource "aws_instance" "devops_server" {
  ami = "${data.aws_ami.devops_ubuntu_xenial.id}"
  instance_type = "m4.2xlarge"
  tags {
    Name = "devops_server"
  }
  root_block_device {
    volume_size = "${var.main_server_disk_gb}"
  }
  key_name = "${aws_key_pair.devops_key.key_name}"
  subnet_id = "${aws_subnet.devops_subnet.id}"
  vpc_security_group_ids = [ "${aws_security_group.devops_security.id}" ]
  timeouts {
    create = "60m"
  }
  connection {
    user = "ubuntu"
    private_key = "${file("../secrets/devops-server.pem")}"
    timeout = "30m"
  }
  provisioner "remote-exec" {

  }
}

variable "hostnames" {
  type    = "list"
  default = [
    "course",
    "gitlab",
    "jenkins",
    "kibana",
    "rancher",
    "kube",
    "swarm",
    "registry",
    "grafana",
    "vault",
    "prometheus",
    "logs",
    "bamboo",
    "concourse",
    "bitbucket",
    "consul",
    "rundeck"
  ]
}

resource "cloudflare_record" "dns_record" {
  domain   = "${var.cloudflare_zone}"
  type     = "A"
  count    = "${length(var.hostnames)}"
  name     = "${element(var.hostnames, count.index)}"
  value    = "${data.aws_eip.public_ip.public_ip}"
  ttl      = 120
}

output "ip" {
  value = "${aws_instance.devops_server.public_ip}"
}

output "eip" {
  value = "${data.aws_eip.public_ip.public_ip}"
}
