
resource "aws_key_pair" "student_test_key" {
  key_name = "student_test_key" 
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgYuUZ5RUzq6lT/ztjGOWviPh+E8zKUHHIqKMt21myDn9Ta3utwEMBzYvNrHZqeUazL/mRyUi2SUYHGxqakVqB+adJrj9JiNDtEZgcbbVtrtGecQ100Cysju301XvVF9aIMVyZzSTi2bGzcAUsQd/bq+bLr3D8DfWidZQrDvY1xxMGsftOGhesnVIA4cM9p3fv+x7nk5tLp1MygZF2cPgEBXFvS3EJW3ogJMZk2nrI2gEq4Kvdi+UGN9KflFgJN7nvUtZ6hxyvx902EZLvuBPZ/9e0fUXxxyCYMX969W+HxZQPPKq3Zii8kZZtf2lwXCpDyCkRJsD82vYklatpjeM/UFvfSNTYbqjl47mnhq+PxLCYZM3IIUAiL3CqCaseNHp/f62NGbE4U0tbLXyxqU6RAamDTF3zBPWiHPARDRLgWVTZ+lZZo9lLrtNsxovT4gMcNKrVQKXx6tM1DJmWFEah6uSh9j72kswd7iRpmFRyA9DcRoe6ScaWPgnKxUEdKA4hYp5bgra6OPhKB5Ty+G758mHfkZIukkTSrSIw7861mts5Y7lRhzhO7dJ0GZI3ejwY+75lhnabrrj24W9EeHI95ODe1gxbkCZkpa5cXDA7U9lk+zTlqZGFi/J3bEW+4ZFMSC3sstQduY8SqQVL4mIIkncX+NLp+iI1Td3yqlbdbQ== student@extremeautomation.io"
}

resource "aws_instance" "test_machine_linux" {
  ami = "${data.aws_ami.devops_ubuntu_trusty.id}"
  instance_type = "t2.medium"
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
