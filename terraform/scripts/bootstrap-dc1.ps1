# Change Administrator password
cmd.exe /c net user Administrator Secret555

# Change hostname and reboot
Rename-Computer -NewName "DC1" -Restart
