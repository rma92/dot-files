set telegraf_conf_dir=%~dp0
telegraf --config %telegraf_conf_dir%telegraf.conf service install

