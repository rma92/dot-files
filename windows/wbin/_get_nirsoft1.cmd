if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://www.nirsoft.net/utils/searchmyfiles-x64.zip" --output searchmyfiles-x64.zip
curl %CURL_PROXY_OPTS% -L "https://www.nirsoft.net/utils/pinginfoview.zip" --output pinginfoview.zip
curl %CURL_PROXY_OPTS% -L "https://www.nirsoft.net/utils/resourcesextract-x64.zip" --output resourcesextract-x64.zip
powershell -command "Expand-Archive -Force searchmyfiles-x64.zip ."
powershell -command "Expand-Archive -Force pinginfoview.zip ."
powershell -command "Expand-Archive -Force resourcesextract-x64.zip ."