# 1. Creating a CSV file
$CSVData = @'
FirstName,Initials,LastName,UserPrincipalName,Alias,Description,
Password
P, D, Rowley, PDR, Peter, Data Team, Christmas42
C, F, Smith, CFS, Claire, Receptionist, Christmas42
Billy, Bob, JoeBob, BBJB, BillyBob, One of the Bobs, Christmas42
Malcolm, D, Duewrong, Malcolm, Malcolm, Mr. Danger, Christmas42
'@
$CSVData | Out-File -FilePath C:\Users\Administrator\Users.csv

# 2. Importing and displaying the CSV
$Users = Import-CSV -Path C:\Users\Administrator\Users.csv |
Sort-Object -Property Alias
$Users | Format-Table

# 2.1 Create IT OU
New-ADOrganizationalUnit -Name "IT" -Path "DC=grupo4,DC=org"

# 3. Adding the users using the CSV
$Users |
ForEach-Object -Parallel {
$User = $_
# Create a hash table of properties to set on created user
$Prop = @{}
# Fill in values
$Prop.GivenName = $User.FirstName
$Prop.Initials = $User.Initials
$Prop.Surname = $User.LastName
$Prop.UserPrincipalName = $User.UserPrincipalName + "@grupo4.org"
$Prop.Displayname = $User.FirstName.Trim() + " " +
$User.LastName.Trim()
$Prop.Description = $User.Description
$Prop.Name = $User.Alias
$PW = ConvertTo-SecureString -AsPlainText $User.Password -Force
$Prop.AccountPassword = $PW
$Prop.ChangePasswordAtLogon = $true
$Prop.Path = 'OU=IT,DC=grupo4,DC=org'
$Prop.Enabled = $true
# Now Create the User
New-ADUser @Prop
# Finally, Display User Created
"Created $($Prop.Name)"
}

# 4. Showing all users in AD (grupo4.org)
Get-ADUser -Filter * -Property Description |
Format-Table -Property Name, UserPrincipalName, Description
