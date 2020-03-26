
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
        [pscredential]$Cred
    
    )    
    
    Import-DscResource -ModuleName ServerApps 
    #$cred = Get-Credential
    #Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    
    
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

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowDomainUser = $true
            PSDscAllowPlainTextPassword = $true
        }
    )

}


$MsiSettings = @(

   @{MsiFile = '7z1900-x64.msi'; ProductID = '23170F69-40C1-2702-1900-000001000000';  Name = '7-Zip 19.00 (x64 edition)'; Arguments = '/norestart'},
   @{MsiFile = 'googlechromestandaloneenterprise64.msi'; ProductID = '09D53CC6-0A7A-3BE2-B558-542159936402';  Name = 'Google Chrome'}


)

InstallApplications -StorageAccountName 'storegeforautomation' -ShareName 'products' -MsiSettings $MsiSettings -ConfigurationData $ConfigData -verbose