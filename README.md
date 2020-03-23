# Deploy With Azure Automation

Project to deploy software to Azure VMs using Azure Automation DSC and Azure Storage to host source files.

# Architecture Components

## Azure Automation

We use Azure Automation to push configuration to VMs

### Highlevel Steps

1. Create DSC Config
1. Upload DSC config to Azure Automation
![State Configuration](./Images/StateConfigs.png)
1. Connect the Node
1. Monitor Results in Azure Monitor
![Monitor Results](./Images/ConfigMonitor.png)

## Azure Storage Account
1. We need a general-purposev2 type Storage Account to host Installation Sources (msi). Sample Storage Account configuration is as follows.

![Storage Account](./Images/AzureStorage.png)
2. Create an azure file share

![Create Azure File Share](./Images/CreateFileShare.jpg)


# Sample Codes

List default Resources available

```PowerShell
Get-DscResource -Module PSDesiredStateConfiguration
```

List Configurable Properties for a Resource

```PowerShell
Get-DscResource -Name WindowsFeature -Syntax 
  
WindowsFeature [String] #ResourceName
{
    Name = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [IncludeAllSubFeature = [bool]]
    [LogPath = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [Source = [string]]
} 
```
Sample Windows Feature Config
 
```PowerShell
configuration TestConfig
{
    Node IsWebServer
    {
        WindowsFeature IIS
        {
            Ensure               = 'Present'
            Name                 = 'Web-Server'
            IncludeAllSubFeature = $true
        }
    }
 
    Node NotWebServer
    {
        WindowsFeature IIS
        {
            Ensure               = 'Absent'
            Name                 = 'Web-Server'
        }
    }
} 
```

To Use Azure Automation Credentials in a script;

![Azure Automation Credentials](./Images/AutomationCredentials.png))


```PowerShell
$myCredential = Get-AutomationPSCredential -Name 'MyCredential'
$userName = $myCredential.UserName
$securePassword = $myCredential.Password
$password = $myCredential.GetNetworkCredential().Password 
```

To connect a node in a workflow use the following cmdlet.

```PowerShell
Register-AzureRmAutomationDscNode
        -AzureVMName <String>
        [-NodeConfigurationName <String>]
        [-ConfigurationMode <String>]
        [-ConfigurationModeFrequencyMins <Int32>]
        [-RefreshFrequencyMins <Int32>]
        [-RebootNodeIfNeeded <Boolean>]
        [-ActionAfterReboot <String>]
        [-AllowModuleOverwrite <Boolean>]
        [-AzureVMResourceGroup <String>]
        [-AzureVMLocation <String>]
        [-ResourceGroupName] <String>
        [-AutomationAccountName] <String>
        [-DefaultProfile <IAzureContextContainer>]
        [<CommonParameters>]
```


# Referneces
- [Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Azure Autamation State Configuration](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started)
- [Azure Automation Credential](https://docs.microsoft.com/en-us/azure/automation/shared-resources/credentials)


# Tools
- [FlowCharts](https://www.draw.io/)
- [MindMapping](https://www.mindmeister.com/)