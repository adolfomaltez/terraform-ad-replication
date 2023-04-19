output "xfreerdp_output" {
  description = "ID of the EC2 instance"
  sensitive   = true
  value       = [
    "",
    "Wait a couple of minutes for servers to be ready!!",
    "Connect to instances using the following commands:",
    "DC1:    xfreerdp /cert:ignore /u:Administrator /p:'Secret555'  /v:${aws_instance.windows-server-dc1.public_dns}",
    "DC2:    xfreerdp /cert:ignore /u:Administrator /p:'Secret555'  /v:${aws_instance.windows-server-dc2.public_dns}",
    "UKDC1:  xfreerdp /cert:ignore /u:Administrator /p:'Secret555'  /v:${aws_instance.windows-server-ukdc1.public_dns}"
  ]
}
