Param(
[Parameter(Mandatory = $true)]
[string]$StorageAccountName, 
[Parameter(Mandatory = $true)]
[string]$AutomationAccountName,
[Parameter(Mandatory = $true)]
[string]$ResourceGroupName,
[Parameter(Mandatory = $true)]
[string]$ShareName,
[Parameter(Mandatory = $true)]
[string]$MsiSettingsFile,
[Parameter(Mandatory = $true)]
[string]$CredentialAssetName,
[Parameter(Mandatory = $true)]
[string]$ConfigurationName
)

$Path = "\\$StorageAccountName.file.core.windows.net\$ShareName"
$VerbosePreference='Continue'

Function Connect-toAzure {


Param (

[Hashtable]$connection

)

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

# Connect to azure to use Azure Automation commandlets. 
# Wrap authentication in retry logic for transient network failures
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}


}

$ParametersString= @"
StorageAccountName = $StorageAccountName
ShareName = $ShareName
MsiSettingsFile = $MsiSettingsFile
CredentialAssetName = $CredentialAssetName
Path = $Path
"@

"Script Started with the following parameters. `n$ParameterSString"


$Cred = Get-AutomationPSCredential -Name $CredentialAssetName

# get the file
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey ($Cred.GetNetworkCredential().Password)
Get-AzureStorageFileContent -ShareName $ShareName -Path $MsiSettingsFile -context $storageContext
$MsiSettings = Import-PowerShellDataFile $MsiSettingsFile -erroraction stop
$MsiSettings.MsiSettings

# get the default connection of azure automation which is named as AzureRunAsAconnection by default.
$connection = Get-AutomationConnection -Name AzureRunAsConnection
Connect-toAzure -connection $connection | out-null

<# you can also use automation variables in the script to set and get msisettings hastable. Set the Variable
$AzureContext = Get-AzSubscription -SubscriptionId $connection.SubscriptionID
Set-AzAutomationVariable -AutomationAccountName $AutomationAccountName -Name $VariableName -ResourceGroupName $ResourceGroupName -Value ($MsiSettings.MsiSettings) -Encrypted $False -verbose
#>
# Now Lets compile
$Parameters = @{
    'Sharename' = $ShareName
    'StorageAccountName' = $StorageAccountName
    'CredentialAssetName' = $CredentialAssetName
    'MsiSettings' = $MsiSettings.MsiSettings
}

$ConfigurationData  = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowDomainUser = $true
            PSDscAllowPlainTextPassword = $true
        }
    )

}
Start-AzAutomationDscCompilationJob -ResourceGroupName $ResourceGroupName  -AutomationAccountName $AutomationAccountName -ConfigurationName $ConfigurationName -Parameters $Parameters -ConfigurationData $ConfigurationData 
