1. Azure VM Templatelerinin dinamik olarak listelenerek deployment başlangıcına seçenek oluşturmak (Powershell Azure mdoule)
1. IAS tarafındaki sunucularına uygulama deploy edilmesi msi (Azure Automation & Powershell DSC)
1. Azure kaynaklarının bakım moduna alınması.  (?)

# Next Steps
- Get feedback about Partial DSC in Azure Automation (https://feedback.azure.com/forums/246290-automation/suggestions/13704216-provide-support-for-dsc-partial-configuration#{toggle_previous_statuses})
- Isolate App PArameters to an hashtable and make ServerApps.ps1 a dynamic configuration
```PowerShell
@{

    7zip = @ { Name ='7-Zip 19.00 (x64 edition)', Msi = '7z1900-x64.msi' , ProductId = '23170F69-40C1-2702-1900-000001000000' }
    Chrome = @ { Name ='GoogleChrome', Msi = 'Chrome.msi' , ProductId = '34r345435-40C1-2702-1900-000001000000' }

}
``` 