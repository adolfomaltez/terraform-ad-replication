
# Create EC2 Instance: DC2
resource "aws_instance" "windows-server-dc2" {
  ami                         = var.AMI
  instance_type               = var.windows_instance_type
  subnet_id                   = aws_subnet.prod-subnet-us.id
  vpc_security_group_ids      = [aws_security_group.aws-windows-sg.id]
  associate_public_ip_address = var.windows_associate_public_ip_address
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  private_ip                  = "10.10.10.12"
  user_data                   = file("scripts/winrm.ps1")
  get_password_data           = true

  # Root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  # Copy powershell scripts directory
  provisioner "file" {
    source      = "scripts/"
    destination = "C:/Users/Administrator/Desktop/scripts/"
    connection {
      type     = "winrm"
      user     = "Administrator"
      password = rsadecrypt(self.password_data,tls_private_key.key_pair.private_key_pem)
      host     = self.public_ip
      port     = 5986
      https    = true
      insecure = true
    }
  }

  # Bootstrap server (change Administrator password, hostname and reboot)
  provisioner "remote-exec" {
      inline = [         
          "powershell.exe -ExecutionPolicy Bypass -File C:/Users/Administrator/Desktop/scripts/bootstrap-dc2.ps1"
      ]
      on_failure = continue
      connection {
        type     = "winrm"
        user     = "Administrator"
        password = rsadecrypt(self.password_data,tls_private_key.key_pair.private_key_pem)
        host     = self.public_ip
        port     = 5986
        https    = true
        insecure = true
      }
  }

  # Define name
  tags = {
    Name        = "dc2"
    Environment = "prod"
  }
  depends_on = [aws_key_pair.key_pair]
}
