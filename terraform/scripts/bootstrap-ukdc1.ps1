# Change Administrator password
cmd.exe /c net user Administrator Secret555
 
#0.1 Change DNS server IP on DC2
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses ("10.10.10.11")
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("10.10.10.11")
Set-DnsClientServerAddress -InterfaceIndex 7 -ServerAddresses ("10.10.10.11")

# Change hostname and reboot
Rename-Computer -NewName "UKDC1" -Restart
