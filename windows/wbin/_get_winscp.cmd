if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://versaweb.dl.sourceforge.net/project/winscp/WinSCP/6.1.2/WinSCP-6.1.2-Portable.zip" --output WinSCP-6.1.2-Portable.zip
powershell -command "Expand-Archive -Force WinSCP-6.1.2-Portable.zip winscp"
move winscp\*.exe .
rmdir /s /q winscp
del /q WinSCP-6.1.2-Portable.zip
