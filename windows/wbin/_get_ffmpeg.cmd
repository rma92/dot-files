if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" --output ffmpeg-master-latest-win64-gpl.zip
powershell -command "Expand-Archive -Force ffmpeg-master-latest-win64-gpl.zip ffmpeg"
move ffmpeg\ffmpeg-master-latest-win64-gpl\bin\*.* .
rmdir /s /q ffmpeg
del /q ffmpeg-master-latest-win64-gpl.zip
