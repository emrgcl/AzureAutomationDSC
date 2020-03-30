#Requires -Version 5.0

[CmdletBinding()]
Param(
    [Parameter()]
    [string[]]
    $ComputerName = @('localhost'),
    [string]$OutputPath=$env:TEMP
)

[DscLocalConfigurationManager()]
Configuration ResetLCM {
    Param (
        [String[]]
        $NodeName
    )
    Node $NodeName {
        Settings {
            ActionAfterReboot              = 'ContinueConfiguration'
            AllowModuleOverwrite           = $false
            CertificateID                  = $null
            ConfigurationDownloadManagers  = @{} 
            ConfigurationID                = $null
            ConfigurationMode              = 'ApplyAndMonitor'
            ConfigurationModeFrequencyMins = 15
            DebugMode                      = @('NONE')
            MaximumDownloadSizeMB          = 500
            RebootNodeIfNeeded             = $True
            RefreshFrequencyMins           = 30
            RefreshMode                    = 'PUSH'
            ReportManagers                 = @{}
            ResourceModuleManagers         = @{}
            SignatureValidations           = @{}
            StatusRetentionTimeInDays      = 10
        }
    }
}
Write-Verbose "Working on computer $Computer, Output Path: $OutputPath"
ResetLCM -NodeName $ComputerName -OutputPath $OutputPath

Set-DscLocalConfigurationManager -Path $OutputPath -ComputerName $ComputerName