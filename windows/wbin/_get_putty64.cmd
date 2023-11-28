if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=
curl %CURL_PROXY_OPTS% -L "https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe" --output putty.exe
curl %CURL_PROXY_OPTS% -L "https://the.earth.li/~sgtatham/putty/latest/w64/pscp.exe" --output pscp.exe

curl %CURL_PROXY_OPTS% -L "https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe" --output plink.exe
curl %CURL_PROXY_OPTS% -L "https://the.earth.li/~sgtatham/putty/latest/w64/pageant.exe" --output pageant.exe
curl %CURL_PROXY_OPTS% -L "https://the.earth.li/~sgtatham/putty/latest/w64/puttygen.exe" --output puttygen.exe
curl %CURL_PROXY_OPTS% -L "https://the.earth.li/~sgtatham/putty/latest/w64/pterm.exe" --output pterm.exe

