if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://newcontinuum.dl.sourceforge.net/project/hwinfo/Windows_Portable/hwi_772.zip" --output hwi_772.zip
powershell -command "Expand-Archive -Force hwi_772.zip hwi772"
move hwi772\*.exe .
rmdir /s /q hwi772
del /q hwi_772.zip
