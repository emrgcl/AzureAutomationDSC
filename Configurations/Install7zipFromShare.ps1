Configuration Install7Zip
{
    [CmdletBinding()]
    Param(
    [string]$StorageAccountName,
    [string]$ShareName
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    $Credential = Get-Credential
    $Path = "\\$StorageAccountName.file.core.windows.net\$ShareName"
    Write-Verbose "FilePath: $Path"
    Write-Verbose "UserName: $($Cred.UserName)"

    Node localhost
    {
        File MSICopy
        {
            Ensure = "Present"
            Type = "File"
            SourcePath = "$Path\7z1900-x64.msi"
            DestinationPath = "C:\Packages\7z1900-x64.msi"
            Credential = $Credential
            Recurse = $true
        }

        Package Install7Zip
        {
            Ensure = 'Present'
            Name = '7-Zip 19.00 (x64 edition)'
            Path = "C:\Packages\7z1900-x64.msi"
            ProductId = '23170F69-40C1-2702-1900-000001000000'
            DependsOn = "[File]MSICopy"


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


Install7Zip -ShareName 'products' -StorageAccountName 'storegeforautomation' -ConfigurationData $ConfigData