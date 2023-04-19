# 1. Importing the DHCP Server module
Import-Module DHCPServer -WarningAction SilentlyContinue

# 2. Creating an IPv4 scope
$SCOPEHT = @{
Name = 'grupo4org'
StartRange = '10.10.10.150'
EndRange = '10.10.10.199'
SubnetMask = '255.255.255.0'
ComputerName = 'DC1.grupo4.org'
}
Add-DhcpServerV4Scope @SCOPEHT

# 3. Getting IPv4 scopes from the server
Get-DhcpServerv4Scope -ComputerName DC1.grupo4.org

# 4. Setting server-wide option values
$OPTION1HT = @{
ComputerName = 'DC1.grupo4.org' # DHCP Server to Configure
DnsDomain = 'grupo4.org' # Client DNS Domain
DnsServer = '10.10.10.11' 

# Client DNS Server
}
Set-DhcpServerV4OptionValue @OPTION1HT

# 5. Setting a scope-specific option
$OPTION2HT = @{
ComputerName = 'DC1.grupo4.org' # DHCP Server to Configure
Router = '10.10.10.1'
ScopeID = '10.10.10.0'
}
Set-DhcpServerV4OptionValue @OPTION2HT

# 6. Viewing server options
Get-DhcpServerv4OptionValue | Format-Table -AutoSize

# 7. Viewing scope-specific options
Get-DhcpServerv4OptionValue -ScopeId '10.10.10.0' |
Format-Table -AutoSize

# 8. Viewing DHCPv4 option definitions
Get-DhcpServerv4OptionDefinition | Format-Table -AutoSize
