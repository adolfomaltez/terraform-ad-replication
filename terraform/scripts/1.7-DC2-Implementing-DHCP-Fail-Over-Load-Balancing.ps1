# 1. Installing the DHCP server feature on DC2
Import-Module -Name ServerManager -WarningAction SilentlyContinue
$FEATUREHT = @{
Name = 'DHCP'
IncludeManagementTools = $True
}
Install-WindowsFeature @FEATUREHT

# 2. Letting DHCP know it is fully configured
$IPHT = @{
Path = 'HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12'
Name = 'ConfigurationState'
Value = 2
}
Set-ItemProperty @IPHT

# 3. Authorizing the DHCP server in AD
Import-Module -Name DHCPServer -WarningAction 'SilentlyContinue'
Add-DhcpServerInDC -DnsName DC2.grupo4.org

# 4. Viewing authorized DHCP servers in the Reskit domain
Get-DhcpServerInDC

# 5. Configuring failover and load balancing
$FAILOVERHT = @{
ComputerName = 'DC1.grupo4.org'
PartnerServer = 'DC2.grupo4.org'
Name = 'DC1-DC2'
ScopeID = '10.10.10.0'
LoadBalancePercent = 60
SharedSecret = 'Secret555'
Force = $true
Verbose = $True
}
Invoke-Command -ComputerName DC1.grupo4.org -ScriptBlock {
Add-DhcpServerv4Failover @Using:FAILOVERHT
}

# 6. Getting active scopes (from both servers!)
$DHCPServers = 'DC1.grupo4.org', 'DC2.grupo4.org'
$DHCPServers | 
ForEach-Object {
"Server: $_" | Format-Table
Get-DhcpServerv4Scope -ComputerName $_ | Format-Table
}

# 7. Viewing DHCP server statistics from both DHCP Servers
$DHCPServers |
ForEach-Object {
"Server: $_" | Format-Table
Get-DhcpServerv4ScopeStatistics -ComputerName $_ | Format-Table
}

# 8. Viewing DHCP reservations from both DHCP Servers
$DHCPServers |
ForEach-Object {
"Server: $_" | Format-Table
Get-DhcpServerv4Reservation -scope 10.10.10.42 -ComputerName $_ | Format-Table
}
