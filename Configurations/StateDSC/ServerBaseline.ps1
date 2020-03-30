configuration InstallApplications
{
    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,
        [Parameter(Mandatory = $true)]
        [string]$ShareName,
        [Parameter(Mandatory = $true)]
        $MsiSettings,
        [string]$CredentialAssetName
    
    )    
    
    Import-DscResource -ModuleName ServerApps 
    
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    
    
    node 'localhost'
    {
        AppBaseline Applications {

            StorageAccountName = $StorageAccountName
            ShareName = $ShareName
            Cred  = $cred
            MsiSettings =  $MsiSettings
        }
    }
}



