#!/bin/bash
# mkdir ~/.screen && chmod 777 ~/.screen

mkdir -p /run/screen
mkdir -p /run/sshd
chmod -Rf 777 /run/screen
# export SCREENDIR=$HOME/.screen

mkdir -p $START_DIR

mkdir -p ~/.local/share/code-server/User
mv /app/settings.json ~/.local/share/code-server/User/settings.json
chmod a+rx ~/.local/share/code-server/User/settings.json
mv /app/rclone-tasks.json ~/.local/share/code-server/User/tasks.json
chmod a+rx ~/.local/share/code-server/User/tasks.json
rm -rf ~/.local/share/code-server/User/argv.json
mv /app/argv.json ~/.local/share/code-server/User/argv.json
chmod a+rx ~/.local/share/code-server/User/argv.json

mkdir -p ~/.config/code-server
rm -rf ~/.config/code-server/config.yaml
mv /app/config.yaml ~/.config/code-server/config.yaml
chmod a+rx ~/.config/code-server/config.yaml

# nginx
sed -i "s|iPORT|$PORT|g" /etc/nginx/http.d/default.conf
sed -i 's/#gzip[ ]on;/gzip on;/g' /etc/nginx/nginx.conf
sed -i 's/client_max_body_size[ ]1m;/client_max_body_size 0;/g' /etc/nginx/nginx.conf

# modify index.html title
sed -i "s|Grad School HTML5 Template|Grad School|g" /app/templatemo_557_grad_school/index.html

#version="$(curl -fsSL https://api.github.com/repos/coder/code-server/releases | awk 'match($0,/.*"html_url": "(.*\/releases\/tag\/.*)".*/)' | head -n 1 | awk -F '"' '{print $4}')"

version="$(curl -fsSLI -o /dev/null -w "%{url_effective}" https://github.com/coder/code-server/releases/latest)"

version="${version#https://github.com/coder/code-server/releases/tag/}"

version="${version#v}"

echo "$version"

wget https://github.com/coder/code-server/releases/download/v${version}/code-server-${version}-linux-amd64.tar.gz -O /app/math.tar.gz

tar -zxf /app/math.tar.gz

rm -rf /app/math.tar.gz

mv /app/code-server-${version}-linux-amd64 /app/euler

chmod -Rf 777 /app/euler
#chmod +rwx /euler/bin/code-server

/app/euler/bin/code-server --install-extension /app/actboy168.tasks-0.11.1.vsix
/app/euler/bin/code-server --install-extension ms-python.python
/app/euler/bin/code-server --install-extension james-yu.latex-workshop
/app/euler/bin/code-server --install-extension ms-azuretools.vscode-docker
/app/euler/bin/code-server --install-extension formulahendry.code-runner
/app/euler/bin/code-server --install-extension MS-CEINTL.vscode-language-pack-zh-hans
rm -rf /app/actboy168.tasks-0.11.1.vsix

# download ms-vscode.cpptools
# https://stackoverflow.com/questions/66134532/vscode-marketplace-extension-corrupt-zip-end-of-central-directory-record-signa
url=https://marketplace.visualstudio.com/items/ms-vscode.cpptools/changelog
wget $url -O changelog
oldver=`cat changelog |grep -o '.\{0,0\}## Version.\{0,8\}'|head -n 1 |cut -d' ' -f3|cut -d: -f1`
ver=`echo $oldver |awk -F'.'  '{print $1"."$2"."$3+1 }'`

rm -rf changelog

while ! wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/cpptools/$ver/vspackage?targetPlatform=alpine-x64 -O /app/ms-vscode.cpptools-$ver@alpine-x64.vsix.gz
do
    sleep 5
done

gunzip /app/ms-vscode.cpptools-$ver@alpine-x64.vsix.gz

/app/euler/bin/code-server --install-extension /app/ms-vscode.cpptools-$ver@alpine-x64.vsix

rm -rf /app/ms-vscode.cpptools-$ver@alpine-x64.vsix

# AriaNg

version="$(curl -fsSL https://api.github.com/repos/mayswind/AriaNg/releases | awk 'match($0,/.*"html_url": "(.*\/releases\/tag\/.*)".*/)' | head -n 1 | awk -F '"' '{print $4}')"

version="${version#https://github.com/mayswind/AriaNg/releases/tag/}"

version="${version#v}"

echo "$version"

wget https://github.com/mayswind/AriaNg/releases/latest/download/AriaNg-${version}.zip -O /app/AriaNg.zip

unzip -o /app/AriaNg.zip -d /app/AriaNg/

mkdir -p /app/Downloads
mkdir -p /app/aria2

touch /app/aria2/aria2.session
chmod 777 /app/aria2/aria2.session

rm -rf /app/AriaNg.zip

#run ttyd
# screen_name="ttyd"
# screen -dmS $screen_name
# cmd="/usr/local/bin/ttyd -p 7681 -c root:c68.300OQa bash";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'

#nohup /math_config.sh &

filebrowser config init
filebrowser config set -b '/file'
filebrowser config set -p 60002
filebrowser users add euler c68.300OQa --perm.admin

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

#qbittorrent-nox -d --webui-port=8082

#supervisord -c /supervisord.conf

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

# echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nnameserver 223.5.5.5\nnameserver 119.29.29.29\nnameserver 127.0.0.11" > /etc/resolv.conf

prl=`grep PermitRootLogin /etc/ssh/sshd_config`
pa=`grep PasswordAuthentication /etc/ssh/sshd_config`
if [[ -n $prl && -n $pa ]]; then
sed -i 's/^#\?Port[ ]22.*/Port 22/g' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
fi


# for redis-server
# sysctl vm.overcommit_memory=1


#/usr/sbin/sshd -D

#while true
#do
#    sleep 5
#done
