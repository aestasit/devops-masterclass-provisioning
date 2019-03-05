
resource "aws_key_pair" "student_test_key" {
  key_name = "student_test_key" 
  public_key = "${file("../secrets/student.pub")}"
}

resource "aws_instance" "test_machine_linux" {
  ami = "${data.aws_ami.ubuntu_xenial.id}"
  instance_type = "t2.small"
  tags {
    Name = "test_machine_linux_${format("%02d", count.index + 1)}"
  }
  root_block_device {
    volume_size = "${var.student_server_disk_gb}"
  }
  count = "${var.student_count}"
  key_name = "${aws_key_pair.student_test_key.key_name}"
  subnet_id = "${aws_subnet.devops_subnet.id}"
  vpc_security_group_ids = [ "${aws_security_group.devops_security.id}" ]
  connection {
    user = "ubuntu"
    private_key = "${file("../secrets/student.pem")}"
    timeout = "30m"
  }
  timeouts {
    create = "60m"
  }
  provisioner "remote-exec" {
    // TODO: add server to monitoring
    // TODO: fix any issues with puppet
  }
}

# 
# resource "aws_instance" "test_machine_windows" {
#   ami = "${data.aws_ami.devops_windows.id}"
#   instance_type = "t2.small"
#   tags {
#     Name = "test_machine_windows_${format("%02d", count.index + 1)}"
#   }
#   connection {
#     type = "winrm"
#     user = "Administrator"
#     password = "${var.admin_password}"
#   }
#   count = "${var.student_count}"
#   subnet_id = "${aws_subnet.devops_subnet.id}"
#   vpc_security_group_ids = [ "${aws_security_group.devops_security.id}" ]
#   key_name = "${aws_key_pair.student_test_key.key_name}"
#   user_data = <<EOF
# <script>
#   winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
# </script>
# <powershell>
#   netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
#   $admin = [adsi]("WinNT://./administrator, user")
#   $admin.psbase.invoke("SetPassword", "${var.admin_password}")
# </powershell>
# EOF
# }
# 
