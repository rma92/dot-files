
REM Edge
REM Set the start page
reg add "HKCU\SOFTWARE\Policies\Microsoft\Edge\Main" /v "StartupPage" /t REG_SZ /d "about:blank" /f

REM Set default search engine to Google
reg add "HKCU\SOFTWARE\Policies\Microsoft\Edge" /v "DefaultSearchProviderEnabled" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Edge" /v "DefaultSearchProviderName" /t REG_SZ /d "Google" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Edge" /v "DefaultSearchProviderSearchURL" /t REG_SZ /d "https://www.google.com/search?q={searchTerms}" /f

REM Install Ublock Origin in Chrome and Edge
reg add "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist\1" /t REG_SZ /d "odfafepnkmbhccpbejgmiehpchacaeak" /f
reg add "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Edge\Extensions\odfafepnkmbhccpbejgmiehpchacaeak" /v "update_url" /t REG_SZ /d "https://edge.microsoft.com/extensionwebstorebase/v1/crx" /f
reg add "HKLM\Software\Policies\Google\Chrome\ExtensionInstallWhitelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f
reg add "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f
reg add "HKLM\Software\Policies\Google\Chrome\URLBlacklist" /v "1" /t REG_SZ /d "javascript://*" /f

REM Disable Edge Autolaunch
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "MicrosoftEdgeAutoLaunch_Async" /t REG_BINARY /d "ffffffffffffffff" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32" /v "MicrosoftEdgeAutoLaunch_Async" /t REG_BINARY /d "ffffffffffffffff" /f

REM Configure ublock origin
REM $RegName = "adminSettings"
REM $RegPathChrome = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy"ccccccccccccc
REM $RegPathEdge = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\3rdparty\extensions\odfafepnkmbhccpbejgmiehpchacaeak\policy" 
REM $RegData = '{"userSettings":{"externalLists":"https://big.oisd.nl/","importedLists":["https://big.oisd.nl/"]},"selectedFilterLists":["user-filters","ublock-filters","ublock-badware","ublock-privacy","ublock-quick-fixes","ublock-unbreak","adguard-generic","easylist","adguard-spyware","adguard-spyware-url","easyprivacy","urlhaus-1","curben-phishing","curben-pup","https://big.oisd.nl/"]}'
