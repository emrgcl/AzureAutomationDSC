
Configuration Install7Zip
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    $Cred = Get-AutomationPSCredential -Name 'ContosoFileShare'

    Node 7ZipMSI
    {
        Package Install7Zip
        {
            Ensure = 'Present'
            Name = '7-Zip 19.00 (x64 edition)'
            Path = 'C:\Products\7z1900-x64.msi'
            ProductId = '23170F69-40C1-2702-1900-000001000000'
            Credential = $Cred

        }
    }
}