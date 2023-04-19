# 1. Importing the ServerManager module
Import-Module -Name ServerManager -WarningAction SilentlyContinue

# 2. Checking DC1 can be resolved
Resolve-DnsName -Name DC1.grupo4.org -Type A

# 3. Checking network connection to DC1
Test-NetConnection -ComputerName DC1.grupo4.org -Port 445
Test-NetConnection -ComputerName DC1.grupo4.org -Port 389

# 4. Adding the AD DS features on UKDC1
$Features = 'AD-Domain-Services'
Install-WindowsFeature -Name $Features -IncludeManagementTools

# 5. Creating a credential and installation hash table
Import-Module -Name ADDSDeployment -WarningAction SilentlyContinue
$URK = "Administrator@grupo4.org"
$PW = 'Secret555'
$PSS = ConvertTo-SecureString -String $PW -AsPlainText -Force
$CredRK = [PSCredential]::New($URK,$PSS)
$INSTALLHT = @{
NewDomainName = 'UK'
ParentDomainName = 'grupo4.org'
DomainType = 'ChildDomain'
SafeModeAdministratorPassword = $PSS
ReplicationSourceDC = 'DC1.grupo4.org'
Credential = $CredRK
SiteName = 'Default-First-Site-Name'
InstallDNS = $false
Force = $true
}

# 6. Installing child domain
Install-ADDSDomain @INSTALLHT

# 7. Looking at the AD forest
Get-ADForest -Server UKDC1.UK.grupo4.org

# 8. Looking at the UK domain
Get-ADDomain -Server UKDC1.UK.grupo4.org

# 9. Checking on user accounts in UK domain
Get-ADUser -Filter * | Format-Table -Property SamAccountName, DistinguishedName

# 10. Checking on user accounts in parent domain
Get-ADUser -Filter * -Server DC1.grupo4.org | Format-Table -Property SamAccountName, DistinguishedName
