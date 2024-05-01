if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://www.sqlite.org/2024/sqlite-tools-win-x64-3450300.zip" --output sqlite-tools-win-x64-3450300.zip
pause
powershell -command "Expand-Archive -Force sqlite-tools-win-x64-3450300.zip ."
