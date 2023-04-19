#1. Installing the AD Domain Services feature and management tools
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

#2. Importing the ADDSDeployment module
Import-Module -Name ADDSDeployment

#3. Examining the commands in the ADDSDeployment module
Get-Command -Module ADDSDeployment

#4. Create a secure password for the Administrator
$PasswordHT = @{
String = 'Secret555'
AsPlainText = $true
Force = $true
}
$PSS = ConvertTo-SecureString @PasswordHT

#5. Test the DC Forest installation starting on DC1
$ForestHT= @{
DomainName = 'grupo4.org'
InstallDNS = $true
NoRebootOnCompletion = $true
SafeModeAdministratorPassword = $PSS
ForestMode = 'WinThreshold'
DomainMOde = 'WinThreshold'
}
Test-ADDSForestInstallation @ForestHT -WarningAction SilentlyContinue

#6. Create theforest root DC on DC1
$NewActiveDirectoryParameterHashTable = @{
DomainName = 'grupo4.org'
SafeModeAdministratorPassword = $PSS
InstallDNS = $true
DomainMode = 'WinThreshold'
ForestMode = 'WinThreshold'
Force = $true
NoRebootOnCompletion = $true
WarningAction = 'SilentlyContinue'
}
Install-ADDSForest @NewActiveDirectoryParameterHashTable

#7. Check the key AD and related services
Get-Service -Name DNS, Netlogon

#8. Check DNS zones
Get-DnsServerZone

#9. Restart DC1 to complete promotion
Restart-Computer -Force
