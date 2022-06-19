[CmdletBinding()]
param(
    [parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[string]$KeyVaultName,

    [parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[string]$Secret_Name,

    [parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[String]$Secret,

    [parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[String]$logon_username,

    [parameter(Mandatory = $true)]
	[ValidateNotNullOrEmpty()]
	[String]$logon_password
)

$ErrorActionPreference = "Stop"
$Error.Clear()

#Connect to Azure using Logon Account Creds
try
{
    $creds = New-Object -typename System.Management.Automation.PSCredential($logon_username, ($logon_password | ConvertTo-SecureString -AsPlainText -Force))
    Connect-AzAccount -Credential $creds | Out-Null
    Write-Output "Successfully Connected to Azure using $logon_username"
}
catch
{
    Write-Output "Failed to authenticate to Azure. Could be Network Issue or Crednetial issue.`n$($Error[0].Exception)"
}

#Convert the Master Account Password to SecureString
$SecureSecret = $Secret | ConvertTo-SecureString -Force -AsPlainText


#Push/Update the Secret to the Azure KeyVault
try
{
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $Secret_Name -SecretValue $SecureSecret | Out-Null
    Write-Output "Pushed the secret successfully"
}
catch
{
    Write-Output "Failed to update the Secret.`n $($Error[0].Exception)"
}