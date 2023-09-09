# Notes

## Use xfreerdp to connect to windows server EC2 instance on AWS
```sh
xfreerdp /u:Administrator /p:'Secret555'  /v:ec2-52-87-171-18.compute-1.amazonaws.com
```


## Enable winrm on windows server
```sh
winrm e winrm/config/listener
```

## Copy files from Linux to Windows using winrm
```sh
apt-get install winrmcp
winrmcp -user=Administrator -pass='ZSecret555' -https -insecure -addr=34.201.53.116:5986 /home/user/scripts C:/User/Administrator/scripts
```

## Copy files from Linux to Windows using powershell
- [Installing PowerShell on Debian Linux](https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.3)


# PowerShell comands.

## Change Name on DC1
```powershell
Rename-Computer -NewName "DC1" -Restart
```

## Change DNS server IP on DC2
```powershell
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("10.10.10.10")
```
## Change Administrator password
    net user Administrator new_password

## PS from Linux

### Install powershell on Debian GNU/Linux
```sh
apt-get install powershell
```

### Run powershell on Linux
```sh
pwsh
```
```powershell                       
Install-Module -Name PSWSMan -Scope AllUsers
Install-WSMan
Disable-WSManCertVerification -All
Enter-PSSession -ComputerName ec2-54-209-85-245.compute-1.amazonaws.com -Authentication Negotiate -Credential Administrator -Port 5986 -UseSSL
```

