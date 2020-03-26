Configuration AppBaseLine
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,
        [Parameter(Mandatory = $true)]
        [string]$ShareName,
        [Parameter(Mandatory = $true)]
        [pscredential]$Cred,
        [Parameter(Mandatory = $true)]
        $MsiSettings

    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    
    $Path = "\\$StorageAccountName.file.core.windows.net\$ShareName"
    $guid = (new-guid).Guid
    Write-Verbose "Msi Source Path: $Path"
    Write-Verbose "UserName: $($Cred.UserName)"
    Write-Verbose "Temporary folder is : c:\$guid"
    Write-Verbose "Number of Software Settings found: $($MsiSettings.Count)"
          
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
            Credential = $Cred
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
<#        FileHelper "RemoveMsi_$ResourceExtension"
        {
            Path = "C:\$Guid"
            Ensure = "Absent"
            DependsOn = "[Package]Install_$ResourceExtension"
        }
  #>
   }
    
}

