#!/bin/bash

nginx -g daemon on

qbittorrent-nox -d --webui-port=8082

aria2c --conf-path=/app/aria2.conf -D

supervisord -c /app/supervisord.conf

while true
do
    sleep 5
done
