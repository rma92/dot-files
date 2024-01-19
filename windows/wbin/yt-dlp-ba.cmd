REM download audio best quality, use ffmpeg to make mp3
yt-dlp --cookies-from-browser firefox -f ba -x --audio-format mp3 --audio-quality 0 "%1"
