REM backup C:\local and the user's desktop to o4b backend in rclone.
REM copy only, no delete or sync. 
REM clear caches for portable browsers before backing up
rmdir /s /q C:\local\FirefoxPortable\Data\profile\cache2\ 
rmdir /s /q C:\local\FirefoxPortable-Noproxy\Data\profile\cache2\ 
rmdir /s /q C:\local\MullvadBrowser2\Data\caches\
rmdir /s /q C:\local\MullvadBrowserProxy\Data\caches\
rmdir /s /q C:\local\GoogleChromePortable\Data\profile\Default\Service Worker\CacheStorage

rclone copy "C:\local" "o4b:sysbackup\%COMPUTERNAME%\local" --exclude "git/**" --exclude "git-sys/**" --exclude "86box/**" --exclude "Downloads/**" --create-empty-src-dirs --log-file="%systemroot%\Logs\rclone-sync.log" --log-level INFO -P
rclone copy "C:\Users\user\Desktop" "o4b:sysbackup\%COMPUTERNAME%\Desktop" --create-empty-src-dirs --log-file="%systemroot%\Logs\rclone-sync.log" --log-level INFO -P

