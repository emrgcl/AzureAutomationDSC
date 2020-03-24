# Deploy With Azure Automation

Project to deploy software to Azure VMs using Azure Automation DSC and Azure Storage to host source files.

1. Create the following Prerequisites
    - Create Azure Automation Account
    - Create an Azure Storage Account File share to host msi/installation source files
1. Get the Storage Account Access Credentials
1. Add Credentials to Azure Automation Assets
1. Create Configuration scripts
    - Get credential for Azure Automation
    - use credential in related configs
1. Deploy config to node

# Architecture Components

Below is a high level view of the solution

![Solution](./Images/Solution.PNG)

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
1. Create an azure file share

![Create Azure File Share](./Images/CreateFileShare.jpg)

1. Get the Storage Account Name and Keys
1. Add Keys to Azure Automation Credentials
1. Add Credentials to Azure Automation DSC Config


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
To mount drive 


![Azure Automation Credentials](./Images/AutomationCredentials.png))

Use Azure Automation Credentials in DSC Config use the following sample. 

```PowerShell

Configuration CredentialSample
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    $Cred = Get-AutomationPSCredential 'SomeCredentialAsset'

    Node $AllNodes.NodeName
    {
        File ExampleFile
        {
            SourcePath      = '\\Server\share\path\file.ext'
            DestinationPath = 'C:\destinationPath'
            Credential      = $Cred
        }
    }
}

```
Package Resource Syntax
```PowerShell
Package [string] #ResourceName
{
    Name = [string]
    Path = [string]
    ProductId = [string]
    [ Arguments = [string] ]
    [ Credential = [PSCredential] ]
    [ LogPath = [string] ]
    [ ReturnCode = [UInt32[]] ]
    [ DependsOn = [string[]] ]
    [ Ensure = [string] { Absent | Present }  ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
```
To get the Storage Account Credentials (keys)

```PowerShell
$resourceGroupName = 'SystemCenter'
$storageAccountName = 'contosofileserver'
$fileShareName = 'Products'
$AccessKey = 'cMFf6HKrhrDdFRH+TKnOqDhz8atKEzt4iYFwmYzVfd0UhgAogc5AMH3mOgWM+K+GQdPQ7ujqyrtSP3x3Gip3nQ=='

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
$storageAccountKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName

$password = ConvertTo-SecureString -String $storageAccountKeys[0].Value -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "AZURE\$($storageAccount.StorageAccountName)", $password
```


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
- [Azure Automation Credential assets](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-compile#credential-assets)
- [Azure Table Storage Powershell](https://docs.microsoft.com/en-us/azure/storage/tables/table-storage-how-to-use-powershell)
- [ComputerManagementDsc](https://github.com/dsccommunity/ComputerManagementDsc)

# Tools
- [FlowCharts](https://www.draw.io/)
- [MindMapping](https://www.mindmeister.com/)