if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/procexp64.exe" --output procexp64.exe
curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/procexp.exe" --output procexp.exe
curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/Autoruns64.exe " --output Autoruns64.exe
curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/Autoruns.exe" --output Autoruns.exe
curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/Procmon.exe" --output Procmon.exe
curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/Procmon64.exe" --output Procmon64.exe
curl %CURL_PROXY_OPTS% -L "https://live.sysinternals.com/RDCMan.exe" --output RDCMan.exe
