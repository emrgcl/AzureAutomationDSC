Configuration InstallPackages
{
    [CmdletBinding()]
    Param(
    [string]$StorageAccountName,
    [string]$ShareName,
    $MsiSettings
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -module ServerApps
    $Credential = Get-Credential
    $Path = "\\$StorageAccountName.file.core.windows.net\$ShareName"
    Write-Verbose "FilePath: $Path"
    Write-Verbose "UserName: $($Cred.UserName)"
    $guid = (new-guid).Guid
    Write-Verbose "Number of Software Settings found: $($MsiSettings.Count)"
    
    
    Node 'localhost'
    {
    Write-Verbose 'Working on Localhost'
        Foreach ($MsiSetting in  $MsiSettings) {
        
        $MsiSetting -match '(?<Parent>\S+)((\.msi)|\s)' | out-null

        $ResourceExtension = $Matches['Parent']
        Write-Verbose -Message "Resource Name Extension: $ResourceExtension, MsiFile = $($MsiSetting.MsiFile)"
    
        File "CopyMsi_$ResourceExtension"
        {
            Ensure = "Present"
            Type = "File"
            SourcePath = "$Path\$($MsiSetting.MsiFile)"
            DestinationPath = "C:\$guid\$($MsiSetting.MsiFile)"
            Credential = $Credential
            Recurse = $true
        }

        Package "Install_$ResourceExtension"
        {
            Ensure = 'Present'
            Name = '7-Zip 19.00 (x64 edition)'
            Path = "C:\$Guid\$($MsiSetting.MsiFile)"
            ProductId = $MsiSetting.ProductID
            Arguments = $MsiSetting.$Arguments
            LogPath = $MsiSetting.$LogPath
            DependsOn = "[File]CopyMsi_$ResourceExtension"
        }
        FileHelper "RemoveMsi_$ResourceExtension"
        {
            Path = "C:\$Guid"
            Ensure = "Absent"
            DependsOn = "[Package]Install_$ResourceExtension"
        }
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

   @{MsiFile = '7z1900-x64.msi'; ProductID = '23170F69-40C1-2702-1900-000001000000';  Name = '7-Zip 19.00 (x64 edition)'},
   @{MsiFile = 'googlechromestandaloneenterprise64.msi'; ProductID = '09D53CC6-0A7A-3BE2-B558-542159936402';  Name = 'Google Chrome'}


)

InstallPackages -ShareName 'products' -StorageAccountName 'storegeforautomation' -ConfigurationData $ConfigData  -MsiSettings $MsiSettings -Verbose


