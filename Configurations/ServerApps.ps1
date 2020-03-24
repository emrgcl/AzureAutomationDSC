Configuration CompositeServerApps {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,
        [Parameter(Mandatory = $true)],
        [string]$ShareName,
        [Parameter(Mandatory = $true)]
        [string]$CredentialAssetName
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    $Path = "\\$StorageAccountName.file.core.windows.net\$ShareName"
    Write-verbose "Path for MSI files : $Path"
    Package Install7Zip
    {
        Ensure = 'Present'
        Name = '7-Zip 19.00 (x64 edition)'
        Path = "$Path\7z1900-x64.msi"
        ProductId = '23170F69-40C1-2702-1900-000001000000'
        Credential = $Cred

    }

    Package ChromePackage
    {
        Ensure = 'Present'
        Name = 'Google Chrome'
        Path = "$Path\googlechromestandaloneenterprise64.msi"
        ProductId = '09D53CC6-0A7A-3BE2-B558-542159936402'
        Credential = $Cred

    }
    
}



