if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip" --output ookla-speedtest-1.2.0-win64.zip
powershell -command "Expand-Archive -Force ookla-speedtest-1.2.0-win64.zip speedtest-cli"
move speedtest-cli\*.exe .
rmdir /s /q speedtest-cli
del /q ookla-speedtest-1.2.0-win64.zip
