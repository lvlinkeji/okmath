#!/bin/bash
# mkdir ~/.screen && chmod 777 ~/.screen
chmod -Rf 777 /run/screen
# export SCREENDIR=$HOME/.screen
#/usr/local/bin/ttyd -p $PORT -c admin:adminks123 bash

#nginx
sed -i 's/^#\?gzip[ ]on;.*/gzip on;/g' /etc/nginx/nginx.conf
sed -i 's/^#\?client_max_body_size[ ]1m;.*/client_max_body_size 0;/g' /etc/nginx/nginx.conf

#run ttyd
screen_name="ttyd"
screen -dmS $screen_name
cmd="/usr/local/bin/ttyd -p 7681 -c root:c68.300OQa bash";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'

filebrowser config init
filebrowser config set -b '/file'
filebrowser config set -p 60002
filebrowser users add root c68.300OQa --perm.admin

#run filebrowser
screen_name="filebrowser"
screen -dmS $screen_name
cmd="filebrowser -r /";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'
#filebrowser username:admin password:admin

#run rclone
screen_name="rclone"
screen -dmS $screen_name
cmd="rclone rcd --rc-web-gui --rc-addr 127.0.0.1:5572 --rc-user root --rc-pass c68.300OQa";
screen -x -S $screen_name -p 0 -X stuff "$cmd"
screen -x -S $screen_name -p 0 -X stuff '\n'

supervisord -c /supervisord.conf

#build and run code-server
screen_name="code-server"
screen -dmS $screen_name
cmd1="export FORCE_NODE_VERSION=16.*";
cmd2="curl -fsSL https://code-server.dev/install.sh | bash";
cmd3="code-server --host 0.0.0.0 --port 8722";
screen -x -S $screen_name -p 0 -X stuff "$cmd1"
screen -x -S $screen_name -p 0 -X stuff '\n'
screen -x -S $screen_name -p 0 -X stuff "$cmd2"
screen -x -S $screen_name -p 0 -X stuff '\n'
screen -x -S $screen_name -p 0 -X stuff "$cmd3"
screen -x -S $screen_name -p 0 -X stuff '\n'


while true
do
    sleep 5
done
