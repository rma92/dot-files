if not defined CURL_PROXY_OPTS set CURL_PROXY_OPTS=

curl %CURL_PROXY_OPTS% -L "https://dl.influxdata.com/telegraf/releases/telegraf-1.32.3_windows_amd64.zip" --output telegraf-1.32.3_windows_amd64.zip
Expand-Archive .\telegraf-1.32.3_windows_amd64.zip -DestinationPath 'C:\Program Files\InfluxData\telegraf'
