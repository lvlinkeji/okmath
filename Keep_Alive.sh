#!/bin/bash

qbittorrent-nox -d --webui-port=8082

supervisord -c /supervisord.conf

while true
do
    sleep 5
done
