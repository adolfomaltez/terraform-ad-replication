# Active Directory replication on AWS

This project deploy 3 EC2 instances t2.micro Windows Server 2019 on AWS using terraform.
 

## Servers:
 - DC1: Primary AD
 - DC2: Replica AD
 - UKDC1: Replica AD

## Run Terraform commands on your PC:
    cd terraform
    terraform init
    terraform plan
    terraform apply
    terraform output -json

## Connect using RDP to every server using the terraform output.
For this, use the output from terraform


## Bootstrap scripts
The following scripts are executed by terraform when the EC2 instance its created. (You dont need to execute)

- winrm.ps1
- bootstrap-dc1.ps1
- bootstrap-dc2.ps1
- bootstrap-ukdc1.ps1



## Provision AD executing the following scripts on the respective server in the current order. 

You can RDP into the servers and execute the respective powershell script.

- 1.1-DC1-Installing-a-Forest-Root-Domain.ps1
- 1.2-DC2-Installing-a-Replica-Domain-Controller.ps1
- 1.3-UKDC1-Installing-a-Child-Domain.ps1
- 1.4-DC1-AddingRemoving-Users-Using-a-CSV-File.ps1
- 1.5-DC1-Installing-DHCP.ps1
- 1.6-DC1-Configuring-DHCP-Scopes-and-Options.ps1
- 1.7-DC2-Implementing-DHCP-Fail-Over-Load-Balancing.ps1
