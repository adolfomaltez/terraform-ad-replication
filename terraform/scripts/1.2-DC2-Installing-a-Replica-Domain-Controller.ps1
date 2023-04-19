# 1. Importing the ServerManager module
Import-Module -Name ServerManager -WarningAction SilentlyContinue

# 2. Checking DC1 can be resolved
Resolve-DnsName -Name DC1.grupo4.org -Type A

# 3. Testing the network connection to DC1
Test-NetConnection -ComputerName DC1.grupo4.org -Port 445
Test-NetConnection -ComputerName DC1.grupo4.org -Port 389

# 4. Adding the AD DS features on DC2
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 5. Promoting DC2 to be a DC
Import-Module -Name ADDSDeployment -WarningAction SilentlyContinue
$User = "Administrator@grupo4.org"
$Password = 'Secret555'
$PWSString = ConvertTo-SecureString -String $Password -AsPlainText -Force
$CredRK = [PSCredential]::New($User,$PWSString)
$INSTALLHT = @{
DomainName = 'grupo4.org'
SafeModeAdministratorPassword = $PWSString
SiteName = 'Default-First-Site-Name'
NoRebootOnCompletion = $true
InstallDNS = $false
Credential = $CredRK
Force = $true
}
Install-ADDSDomainController @INSTALLHT | Out-Null

# 6. Checking the computer objects in AD
Get-ADComputer -Filter * | Format-Table DNSHostName, DistinguishedName

# 7. Rebooting DC2 manually
Restart-Computer -Force

# 8. Checking DCs in grupo4.org
$SearchBase = 'OU=Domain Controllers,DC=grupo4,DC=org'
Get-ADComputer -Filter * -SearchBase $SearchBase -Properties * | Format-Table -Property DNSHostName, Enabled

#9. Viewing grupo4.org domain DCs
Get-ADDomain | Format-Table -Property Forest, Name, ReplicaDirectoryServers
