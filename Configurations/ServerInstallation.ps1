configuration UsingAComposite
{
    Import-DscResource -ModuleName ServerApps 
    
    node localhost
    {
        AppBaseline Applications {

            StorageAccountName = 'ContosoFileServer'
            ShareName = 'Software'
            Cred = Get-AutomationPSCredential -Name $CredentialAssetName
            
            
        }
    }
}

