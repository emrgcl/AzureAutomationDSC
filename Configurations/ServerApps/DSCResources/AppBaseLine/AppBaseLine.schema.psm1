Configuration AppBaseLine
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,
        [Parameter(Mandatory = $true)]
        [string]$ShareName,
        [Parameter(Mandatory = $true)]
        [pscredential]$Cred
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    $Path = "\\$StorageAccountName.file.core.windows.net\$ShareName"
    Write-verbose "Path for MSI files : $Path"
    Write-verbose "UserName to access to Share : $($Cred.UserName)"


    File Copy_7-Zip
    {
        Ensure = "Present"
        Type = "File"
        SourcePath = "$Path\7z1900-x64.msi"
        DestinationPath = "C:\Packages\7z1900-x64.msi"
        Credential = $Credential
        Recurse = $true
    }
    
    Package Install_7-Zip
    {
     
        Ensure = 'Present'
        Name = '7-Zip 19.00 (x64 edition)'
        Path = "$Path\7z1900-x64.msi"
        ProductId = '23170F69-40C1-2702-1900-000001000000'
        Credential = $Cred
        DependsOn = "[File]MSICopy"
    }

    FileHelper Delete_7-Zip
    {
        Path = "C:\Packages\file.txt"
        Ensure = "Absent"
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

