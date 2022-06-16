#!/bin/bash
# mkdir ~/.screen && chmod 777 ~/.screen
mkdir -p /run/screen
mkdir -p /run/sshd
chmod -Rf 777 /run/screen
# export SCREENDIR=$HOME/.screen

mkdir -p $START_DIR

mkdir -p ~/.local/share/code-server/User
mv /settings.json ~/.local/share/code-server/User/settings.json
chmod a+rx ~/.local/share/code-server/User/settings.json
mv /rclone-tasks.json ~/.local/share/code-server/User/tasks.json
chmod a+rx ~/.local/share/code-server/User/tasks.json

mkdir -p ~/.config/code-server
rm -rf ~/.config/code-server/config.yaml
mv /config.yaml ~/.config/code-server/config.yaml
chmod a+rx ~/.config/code-server/config.yaml

#nginx
sed -i "s|iPORT|$PORT|g" /etc/nginx/http.d/default.conf
sed -i 's/#gzip[ ]on;/gzip on;/g' /etc/nginx/nginx.conf
sed -i 's/client_max_body_size[ ]1m;/client_max_body_size 0;/g' /etc/nginx/nginx.conf

version="$(curl -fsSL https://api.github.com/repos/coder/code-server/releases | awk 'match($0,/.*"html_url": "(.*\/releases\/tag\/.*)".*/)' | head -n 1 | awk -F '"' '{print $4}')"

version="${version#https://github.com/coder/code-server/releases/tag/}"

version="${version#v}"

echo "$version"

wget https://github.com/coder/code-server/releases/latest/download/code-server-${version}-linux-amd64.tar.gz -O /math.tar.gz

tar -zxf /math.tar.gz

rm -rf /math.tar.gz

mv /code-server-${version}-linux-amd64 /euler

chmod -Rf 777 /euler
#chmod +rwx /euler/bin/code-server

/euler/bin/code-server --install-extension /actboy168.tasks-0.9.0.vsix
/euler/bin/code-server --install-extension ms-python.python
/euler/bin/code-server --install-extension james-yu.latex-workshop
/euler/bin/code-server --install-extension ms-azuretools.vscode-docker

#run ttyd
# screen_name="ttyd"
# screen -dmS $screen_name
# cmd="/usr/local/bin/ttyd -p 7681 -c root:c68.300OQa bash";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'

nohup /math_config.sh &

filebrowser config init
filebrowser config set -b '/file'
filebrowser config set -p 60002
filebrowser users add root c68.300OQa --perm.admin

#/usr/local/bin/ttyd -p $PORT -c admin:adminks123 bash

#run filebrowser
# screen_name="filebrowser"
# screen -dmS $screen_name
# cmd="filebrowser -r /";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'
#filebrowser username:admin password:admin

#run rclone
# screen_name="rclone"
# screen -dmS $screen_name
# cmd="rclone rcd --rc-web-gui --rc-addr 127.0.0.1:5572 --rc-user root --rc-pass c68.300OQa";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'

qbittorrent-nox -d --webui-port=8082

supervisord -c /supervisord.conf

#build and run code-server
# screen_name="code-server"
# screen -dmS $screen_name
# cmd1="export FORCE_NODE_VERSION=16.*";
# cmd2="curl -fsSL https://code-server.dev/install.sh | bash";
# cmd3="code-server --host 0.0.0.0 --port 8722";
# screen -x -S $screen_name -p 0 -X stuff "$cmd1"
# screen -x -S $screen_name -p 0 -X stuff '\n'
# screen -x -S $screen_name -p 0 -X stuff "$cmd2"
# screen -x -S $screen_name -p 0 -X stuff '\n'
# screen -x -S $screen_name -p 0 -X stuff "$cmd3"
# screen -x -S $screen_name -p 0 -X stuff '\n'

echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 223.5.5.5\nnameserver 119.29.29.29\nnameserver 127.0.0.11" > /etc/resolv.conf

prl=`grep PermitRootLogin /etc/ssh/sshd_config`
pa=`grep PasswordAuthentication /etc/ssh/sshd_config`
if [[ -n $prl && -n $pa ]]; then
sed -i 's/^#\?Port[ ]22.*/Port 22/g' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
fi

/usr/sbin/sshd -D

while true
do
    sleep 5
done
