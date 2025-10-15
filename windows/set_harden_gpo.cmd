REM Add command line to process launch event 4688
REM “Include command line in process creation events” (adds cmdline to 4688): introduced in Windows 8.1 / Server 2012 R2; Microsoft later back-ported to Windows 7 / 8 via KB3004375 (Feb 2015)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1 /f
REM Set “Force subcategory settings to override category settings” via registry
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v SCENoApplyLegacyAuditPolicy /t REG_DWORD /d 1 /f

REM enable process creation
auditpol /set /subcategory:"Process Creation" /success:enable /failure:disable
REM enable process terminate
auditpol /set /subcategory:"Process Termination" /success:enable /failure:disable

REM Logon/Logoff
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"Special Logon" /success:enable
auditpol /set /subcategory:"Account Lockout" /failure:enable
REM Object Access
REM auditpol /set /subcategory:"Removable Storage" /success:enable /failure:enable
REM auditpol /set /subcategory:"Filtering Platform Connection" /success:enable
REM Policy Change
auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:enable
auditpol /set /subcategory:"MPSSVC Rule-Level Policy Change" /success:enable
auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable
 


REM Windows 10 Privacy
REM Set Windows Analytics to limited enhanced if enhanced is enabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v LimitEnhancedDiagnosticDataWindowsAnalytics /t REG_DWORD /d 1 /f
REM Set Windows Telemetry to security only
REM If you intend to use Enhanced for Windows Analytics then set this to "2" instead
REM Note my understanding is W10 Home edition will do a minimum of "Basic"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v MaxTelemetryAllowed /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v ShowedToastAtLevel /t REG_DWORD /d 1 /f
REM Disable location data
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore" /v Location /t REG_SZ /d Deny /f
REM Prevent the Start Menu Search from providing internet results and using your location
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f
REM Disable publishing of Win10 user activity 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 1 /f
REM Disable Win10 settings sync to cloud
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSync /t REG_DWORD /d 2 /f
REM Disable the advertising ID
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f

REM Disable Windows GameDVR (Broadcasting and Recording)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
REM Disable Microsoft consumer experience which prevent notifications of suggested applications to install
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f
REM Disable websites accessing local language list
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f
REM Prevent toast notifications from appearing on lock screen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoToastApplicationNotificationOnLockScreen /t REG_DWORD /d 1 /f
REM Enable anti-spoofing for facial recognition
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures" /v EnhancedAntiSpoofing /t REG_DWORD /d 1 /f
REM Disable other camera use while screen is locked
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreenCamera /t REG_DWORD /d 1 /f
REM Prevent Windows app voice activation while locked
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsActivateWithVoiceAboveLock /t REG_DWORD /d 2 /f
REM Prevent Windows app voice activation entirely (be mindful of those with accesibility needs)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsActivateWithVoice /t REG_DWORD /d 2 /f

REM See https://github.com/atlantsecurity/windows-hardening-scripts/blob/main/Windows-10-Hardening-script.cmd#L953
