if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://github.com/vim/vim-win32-installer/releases/download/v9.1.0/gvim_9.1.0_x86_signed.exe" --output gvim_9.1.0_x86_signed.exe
gvim_9.1.0_x86_signed.exe
