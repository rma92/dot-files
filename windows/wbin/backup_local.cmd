REM backup C:\local and the user's desktop to o4b backend in rclone.
REM copy only, no delete or sync. 
REM Set UTC timestamp
C:
for /f %%i in ('powershell -Command "Get-Date -Format yyyyMMdd-HHmmss -AsUTC"') do set DATE=%%i

REM clear caches for portable browsers before backing up
rmdir /s /q \local\FirefoxPortable\Data\profile\cache2\ 
rmdir /s /q \local\FirefoxPortable-Noproxy\Data\profile\cache2\ 
rmdir /s /q \local\MullvadBrowser2\Data\caches\
rmdir /s /q \local\MullvadBrowserProxy\Data\caches\
rmdir /s /q \local\GoogleChromePortable\Data\profile\Default\Service Worker\CacheStorage

REM rclone copy "\local" "o4b:sysbackup\%COMPUTERNAME%\local" --exclude "git/**" --exclude "git-sys/**" --exclude "86box/**" --exclude "Downloads/**" --create-empty-src-dirs --log-file="%systemroot%\Logs\rclone-sync.log" --log-level INFO -P
rclone copy "\local" "o4b:sysbackup\%COMPUTERNAME%\local" --exclude "git/**" --exclude "git-sys/**" --exclude "86box/**" --exclude "Downloads/**" --create-empty-src-dirs --log-file="%systemroot%\Logs\rclone-sync.log" --log-level INFO -P --backup-dir "o4b:sysbackup\%COMPUTERNAME%\local-archive\%DATE%" --suffix ".bak" --progress
rclone copy "\Users\user\Desktop" "o4b:sysbackup\%COMPUTERNAME%\Desktop" --create-empty-src-dirs --log-file="%systemroot%\Logs\rclone-sync.log" --log-level INFO -P --backup-dir "o4b:sysbackup\%COMPUTERNAME%\Desktop-archive\%DATE%" --suffix ".bak" --progress
REM rclone copy "\Users\user\Desktop" "o4b:sysbackup\%COMPUTERNAME%\Desktop" --create-empty-src-dirs --log-file="%systemroot%\Logs\rclone-sync.log" --log-level INFO -P
