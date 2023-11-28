if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://www.nirsoft.net/utils/searchmyfiles-x64.zip" --output searchmyfiles-x64.zip
powershell -command "Expand-Archive -Force searchmyfiles-x64.zip ."
