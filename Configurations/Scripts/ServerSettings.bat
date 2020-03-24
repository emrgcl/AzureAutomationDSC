Rem   ## Windows sistem bilgisi alinir
Rem   ## Isim Bilgisi aliniyor
Rem   ## FQDN adi tekrar veriliyor
Rem   ## Visualc Runtime kurulumu
Rem   ## Powershell Unrestricted
Rem   ## UAC nin kaldirilmasi
Rem   ## System, Application, Security Eventlog boyutlatini buyutulmesi
Rem   ## Autoupdate kaldiriliyor
Rem   ## PID id lerin gozukmemesi
Rem   ## Firewall Disable
Rem   ## RDP Enable
Rem   ## NLA Enable
Rem   ## Eger NLA enable edilecekse 
Rem   ## 172.25.253.14 NTP olarak ayarlanmasi
Rem   ## Time Zone Istanbul set edilir
Rem   ## IE enhanced security disable
Rem   ## Telnet Client Install
Rem   ## Routelarin girilmesi
Rem   ## UC4 kurulumu
Rem   ## Windows sistem bilgisi alinir
Rem   ## Isim Bilgisi aliniyor
Rem   ## FQDN adi tekrar veriliyor
Rem   ## SNMP Install edilip ayarlanmasi
Rem   ## Administrator renamed_localadmin_account olarak degistiriliyor
@echo on
cls
setlocal enabledelayedexpansion

Rem   ##  Windows sistem bilgisi alinir
For /f "tokens=2 delims=[]" %%G in ('ver') Do (set _version=%%G)
For /f "tokens=2,3,4 delims=. " %%G in ('echo %_version%') Do (set _major=%%G& set _minor=%%H& set _build=%%I)
echo Windows sistem bilgisi alinir

Rem   ## Isim Bilgisi aliniyor


FOR /f "tokens=4" %%q in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Domain"  ^| find /i "REG_SZ"') do set Domainismi=%%q
FOR /f "tokens=4" %%w in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname"  ^| find /i "REG_SZ"') do set Hostismi=%%w

@echo  Domain:"%Domainismi%"
@echo  Host:"%Hostismi%"


echo Isim Bilgisi aliniyor

Rem   ## FQDN adi tekrar veriliyor



REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "NV Domain" /t REG_SZ /d "%Domainismi%" /f
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "NV Hostname" /t REG_SZ /d "%Hostismi%" /f


echo FQDN adi tekrar veriliyor



Rem   ## Visualc Runtime kurulumu
START /WAIT vcredist_x64.exe /Q
echo Visualc Runtime kurulumu


Rem   ## Powershell Unrestricted
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /f /v ExecutionPolicy /t REG_SZ /d Unrestricted
Echo Powershell Unrestricted


Rem   ## UAC nin kaldirilmasi
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /f /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /f /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 0
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /f /v "EnableLUA" /t REG_DWORD /d 0
reg add HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters   /f /v "AutoShareServer" /t REG_DWORD /d 1
Echo UAC nin kaldirilmasi


Rem   ## System, Application, Security Eventlog boyutlatini buyutulmesi
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\System /f /v MaxSize /t  REG_DWORD  /d 1073741824
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Application /f /v MaxSize /t  REG_DWORD  /d 1073741824
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eventlog\Security  /f /v MaxSize /t  REG_DWORD  /d 1073741824
Echo System, Application, Security Eventlog boyutlatini buyutulmesi


Rem   ## Autoupdate kaldiriliyor
REG add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /V DisableWindowsUpdateAccess /T REG_DWORD /F /D 0
REG add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /V ElevateNonAdmins /T REG_DWORD /F /D 0
REG add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /V AUOptions /T REG_DWORD /F /D 2
REG add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /V ScheduledInstallTime /T REG_DWORD /F /D 4
REG add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /V ScheduledInstallDay /T REG_DWORD /F /D 1
Echo Autoupdate kaldiriliyor





Rem   ## PID id lerin gozukmemesi
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfProc\Performance" /v "ProcessNameFormat" /t REG_DWORD /d 2 /f
Echo PID id lerin gozukmemesi acildi


Rem   ## Firewall Disable
netsh advfirewall set allprofiles state off
echo Firewall Disable edildi


Rem   ## RDP Enable
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
echo RDP Enable edildi


Rem   ## NLA Enable
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
echo NLA Enable edildi


Rem   ##  Eger NLA enable edilecekse 
Rem   ##  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /t REG_DWORD /d 2 /f
Rem   ##  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel /t REG_DWORD /d 3 /f
Rem   ##  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f
Rem   ##  echo NLA Enable edildi
Rem   ##  



Rem   ##  172.25.253.14 NTP olarak ayarlanmasi
net start w32time
w32tm /config /syncfromflags:manual /manualpeerlist:"172.25.253.14" /update /reliable:yes
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers  /f /v "" /t REG_SZ /d 6
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers  /f /v 6 /t REG_SZ /d 172.25.253.14
echo 172.25.253.14 NTP olarak ayarlandi


Rem   ## Time Zone Istanbul set edilir
net stop w32time
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\GTB Standard Time" /v "Display" /t REG_SZ /d   "(GMT+02:00) Athens, Bucharest" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\GTB Standard Time"  /v "MUI_Display" /t REG_SZ /d    "@tzres.dll,-1490"  /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v "Display" /t REG_SZ /d    "(GMT+02:00) Istanbul"  /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v "Dlt"  /t REG_SZ /d    "Turkey Daylight Time" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v  "Index" /t REG_DWORD /d 2147483736 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v "MUI_Display" /t REG_SZ /d    "@tzres.dll,-1500"  /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v "MUI_Dlt" /t REG_SZ /d    "@tzres.dll,-1501"  /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v "MUI_Std" /t REG_SZ /d    "@tzres.dll,-1502"  /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v "Std"   /t REG_SZ /d    "Turkey Standard Time" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time" /v  "TZI"   /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2010" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2011" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300010005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2012" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2013" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2014" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2015" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "2016" /t REG_BINARY /d "88ffffff00000000c4ffffff00000a0000000500040000000000000000000300000005000300000000000000" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "FirstEntry" /t REG_DWORD /d 2010 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\Turkey Standard Time\Dynamic DST" /v "LastEntry" /t REG_DWORD /d 2016 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "DaylightName"  /t REG_SZ /d  "@tzres.dll,-1501" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "StandardStart"  /t REG_SZ /d  "00000b00020004000000000000000000" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "StandardName"  /t REG_SZ /d  "@tzres.dll,-1502" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "DaylightStart"  /t REG_SZ /d  "00000300050003000000000000000000" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "TimeZoneKeyName"  /t REG_SZ /d  "Turkey Standard Time" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "DynamicDaylightTimeDisabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"  /v "StandardBias" /t REG_DWORD /d 0 /f
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet001\Control\TimeZoneInformation /v  TimeZoneKeyName /t REG_SZ /d "Turkey Standard Time" /f
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v  TimeZoneKeyName /t REG_SZ /d "Turkey Standard Time" /f
net start W32Time
RunDLL32.exe shell32.dll,Control_RunDLL /S /Q /F timedate.cpl,,/Z "Turkey Standard Time"
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1,True
TZUtil.exe /s "Turkey Standard Time"
echo Time Zone Istanbul set edilir


Rem   ## IE enhanced security disable
REG ADD "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 00000000 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v IsInstalled /t REG_DWORD /d 00000000 /f
echo IE enhanced security disable





Rem   ## Telnet Client Install
dism /online /enable-feature /featurename:TelnetClient
echo Telnet Client kurulumu tamamlandi





Rem   ##  Routelarin girilmesi
for /F "tokens=6" %%i in ('"ipconfig | findstr Connection-specific"') do SET Domain_Nm=%%i
FOR /F "usebackq" %%i IN ('hostname') DO SET Local_Nm=%%i
set ARADA=.
@echo !ARADA!
@echo !Domain_Nm!
@echo !Local_Nm!
set "FQDN_Nm=!Local_Nm!!ARADA!!Domain_Nm!"
@echo %FQDN_Nm%
netdom computername !Local_Nm! /add:!FQDN_Nm!
netdom computername !Local_Nm! /makeprimary:!FQDN_Nm!
route delete 0.0.0.0 mask 0.0.0.0 1.1.1.1

arp -d
ipconfig /flushdns
for /f "tokens=2 delims=:" %%a in (
    'ipconfig ^| find "IP" ^| find "Address" ^| findstr /i /c:"172.21" /i /c:"172.22" /i /c:"172.23" /i /c:"172.24" /i /c:"172.25" /i /c:"172.26" /i /c:"172.27" /i /c:"172.28" /i /c:"172.29" /i /c:"172.30" /i /c:"172.31" /i /c:"172.32" /i /c:"172.33" /i /c:"172.34" /i /c:"172.35" /i /c:"172.36" /i /c:"172.37" /i /c:"172.38" /i /c:"172.39" ^| find /v "v6"') do set IPAddr=%%a
set retcode=%errorlevel%

for /f "tokens=1-3 delims=. " %%x in ("%ipaddr%") do set ipfirst3octets=%%x.%%y.%%z


if NOT %ERRORLEVEL% == 0 (
Echo BAckup IP adresi yanlis girilmis
) ELSE IF %ERRORLEVEL% == 0 ( 

Echo Backup IP adresi %ipaddr%

echo 3 oktet   %ipfirst3octets%

Echo Routelar Siliniyor
route delete 172.25.252.0
route delete 195.87.254.0
route delete 172.25.1.252

Echo Routelar giriliyor
route add -p 172.25.252.0  mask  255.255.252.0      %ipfirst3octets%.254
route add -p 195.87.254.0  mask  255.255.255.240    %ipfirst3octets%.254
route add -p 172.25.1.252  mask  255.255.255.255    %ipfirst3octets%.254

echo  Rouetlar girilmistir
Route Print | findstr "172.25.252.0"
Route Print | findstr "195.87.254.0"
Route Print | findstr "172.25.1.252"
)

echo ROute'lar girildi



Rem   ## UC4 kurulumu

SC QUERY | FIND "SERVICE_NAME: UC4.ServiceManager.UC4PROD"
IF %ERRORLEVEL% EQU 0 (
   echo Uc4 Agenti kuruludur...
   
Goto:devam  
)
set BIT=%PROCESSOR_ARCHITECTURE%
IF %BIT% == x86 (
   @echo 32bit
   @echo INFO:UC4 Service Manager kuruluyor...
  c:\uc4\x86\ServiceManager\bin\UCYBSMgr.exe -install UC4PROD
   @echo INFO:UC4 Service Manager kuruldu...
   @echo INFO:Agent ismi FQDN ismi ile degistiriliyor...
   setlocal enabledelayedexpansion
   for /F "tokens=12" %%i in ('"ipconfig /all | findstr Primary"') do SET LOCAL_IP=%%i
   FOR /F "usebackq" %%i IN (`hostname`) DO SET MYVAR=%%i
   set NOKTA="."
   @echo !NOKTA!
   @echo !LOCAL_IP!
   @echo !MYVAR!
   set "FQDNNEW=!MYVAR!!NOKTA!!LOCAL_IP!"
   @echo %FQDNNEW%
   cscript c:\uc4\replace.vbs "C:\uc4\x86\Agents\Windows\bin\UCXJWI3.ini" "!FQDNNEW!"
   @echo INFO:Agent ismi FQDN ismi ile degistirildi...
   net start UC4.ServiceManager.UC4PROD
   @echo INFO:Agent baslatildi...
   endlocal
) ELSE (
   @echo 64bit
   @echo INFO:UC4 Service Manager kuruluyor...
   c:\uc4\x64\ServiceManager\bin\UCYBSMgr.exe -install UC4PROD
   @echo INFO:UC4 Service Manager kuruldu...
   @echo INFO:Agent ismi FQDN ismi ile degistiriliyor...
   setlocal enabledelayedexpansion
   for /F "tokens=12" %%i in ('"ipconfig /all | findstr Primary"') do SET LOCAL_IP=%%i
   FOR /F "usebackq" %%i IN (`hostname`) DO SET MYVAR=%%i
   set NOKTA="."
   @echo !NOKTA!
   @echo !LOCAL_IP!
   @echo !MYVAR!
   set "FQDNNEW=!MYVAR!!NOKTA!!LOCAL_IP!"
   @echo %FQDNNEW%
   cscript c:\uc4\replace.vbs "C:\uc4\x64\Agents\Windows\bin\UCXJWX6.ini" "!FQDNNEW!"
   @echo INFO:Agent ismi FQDN ismi ile degistirildi...
   net start UC4.ServiceManager.UC4PROD
   endlocal
)
setlocal enabledelayedexpansion
SC QUERY | FIND "SERVICE_NAME: UC4.ServiceManager.UC4PROD"
IF %ERRORLEVEL% EQU 0 (  
    echo INFO:Agent basarili kuruldu... 
) ELSE ( 
    echo INFO:Agent kurulumu basarisiz... 
)

:devam
endlocal
echo UC4 kurulumu



Rem   ##  Windows sistem bilgisi alinir
For /f "tokens=2 delims=[]" %%G in ('ver') Do (set _version=%%G)
For /f "tokens=2,3,4 delims=. " %%G in ('echo %_version%') Do (set _major=%%G& set _minor=%%H& set _build=%%I)
echo Windows sistem bilgisi alinir


Rem   ## Isim Bilgisi aliniyor


FOR /f "tokens=4" %%q in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Domain"  ^| find /i "REG_SZ"') do set Domainismi=%%q
FOR /f "tokens=4" %%w in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname"  ^| find /i "REG_SZ"') do set Hostismi=%%w

@echo  Domain:"%Domainismi%"
@echo  Host:"%Hostismi%"


echo Isim Bilgisi aliniyor

Rem   ## FQDN adi tekrar veriliyor



REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "NV Domain" /t REG_SZ /d "%Domainismi%" /f
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "NV Hostname" /t REG_SZ /d "%Hostismi%" /f


echo FQDN adi tekrar veriliyor





Rem   ## SNMP Install edilip ayarlanmasi

if "%_major%"=="6" (
            if "%_minor%"=="1" (
            Powershell -Command "& {Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ServerManager; Add-WindowsFeature -Name SNMP-Service -IncludeAllSubFeature }"  
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 1 /t REG_SZ /d "localhost" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 6 /t REG_SZ /d "172.25.1.252" /f   
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 7 /t REG_SZ /d "172.25.254.121" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 8 /t REG_SZ /d "172.25.254.122" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 9 /t REG_SZ /d "172.25.254.123" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 10 /t REG_SZ /d "172.25.254.124" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 11 /t REG_SZ /d "172.25.254.125" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 12 /t REG_SZ /d "212.12.128.111" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 13 /t REG_SZ /d "212.12.128.112" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities /V K$CSnMp1945 /T REG_DWORD /F /D 4
            REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /V ElevateNonAdmins /T REG_DWORD /F /D 0
            dism /online /enable-feature /featurename:SNMP
            Rem   ## Administrator renamed_localadmin_account olarak degistiriliyor
            wmic UserAccount where Name="administrator" call rename name="renamed_localadmin_account"
            echo Administrator renamed_localadmin_account olarak degistiriliyor 
            echo Windows 2008 r2 SNMP Install edilip ayarlandi
            echo SNMP Install edilip ayarlandi
            ) else (
            Powershell -Command "& {Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ServerManager; Add-WindowsFeature -Name SNMP-Service -IncludeAllSubFeature -IncludeManagementTools}"  
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 1 /t REG_SZ /d "localhost" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 6 /t REG_SZ /d "172.25.1.252" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 7 /t REG_SZ /d "172.25.254.121" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 8 /t REG_SZ /d "172.25.254.122" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 9 /t REG_SZ /d "172.25.254.123" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 10 /t REG_SZ /d "172.25.254.124" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 11 /t REG_SZ /d "172.25.254.125" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 12 /t REG_SZ /d "212.12.128.111" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers /v 13 /t REG_SZ /d "212.12.128.112" /f
            REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities /V K$CSnMp1945 /T REG_DWORD /F /D 4
            REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /V ElevateNonAdmins /T REG_DWORD /F /D 0 
            dism /online /enable-feature /featurename:SNMP
            Rem   ## Administrator renamed_localadmin_account olarak degistiriliyor
            wmic UserAccount where Name="administrator" call rename name="renamed_localadmin_account"
            echo Administrator renamed_localadmin_account olarak degistiriliyor
            echo Windows 2012 r2 SNMP Install edilip ayarlandi
            echo SNMP Install edilip ayarlandi

            )
)


