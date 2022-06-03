FROM alpine:edge

USER root
ENV TZ="Asia/Shanghai"
ENV LANG C.UTF-8

ADD . /

RUN apk update && \
    apk add --no-cache --no-progress ca-certificates tor wget curl bash vim nano screen python3 py3-pip nginx alpine-sdk libstdc++ libc6-compat libx11-dev libxkbfile-dev libsecret-dev libwebsockets-dev git redis supervisor zip unzip build-base ffmpeg cmake fuse xz yarn nodejs npm gnupg openssh-client gcompat qbittorrent-nox musl-dev tzdata autoconf automake && \
    npm config set python python3 && \
    npm config set unsafe-perm true && \
    npm install -g wstunnel && \
    npm install -g koa-generator && \
    npm install -g pm2 && \
    npm install -g nodemon && \
    chmod +rw /default.conf && \
    chmod +rwx /config.json && \
    chmod +rwx /mathcalc/mathcalc && \
    chmod +rwx /mathcalc/geoip.dat && \
    chmod +rwx /mathcalc/geosite.dat && \
    chmod +rwx /supervisord.conf && \
    chmod +rw /grad_school.zip && \
    chmod +rwx /start.sh && \
    chmod +rwx /math_config.sh && \
    wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /usr/local/bin/ttyd && \
    chmod a+rx /usr/local/bin/ttyd && \
    wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl && \
    chmod a+rx /usr/local/bin/youtube-dl && \
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    curl https://rclone.org/install.sh | bash && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    echo root:c68.300OQa|chpasswd && \
    npm config set python python3 && \
    npm config set unsafe-perm true && \
    rm -rf /etc/nginx/http.d/default.conf && \
    mv /default.conf /etc/nginx/http.d/default.conf && \
    unzip -o /grad_school.zip -d / && \
    chmod -Rf +rw /templatemo_557_grad_school && \
    chmod +rwx /actboy168.tasks-0.9.0.vsix && \
    cp "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" >  /etc/timezone && \
    rm -rf /.git && \
    rm -rf /var/cache/apk/*

# alpine 安装的时候名称是 redis ，启动的时候名称是 redis-server

#nginx配置文件的路径是 /etc/nginx/nginx.conf

#nginx网站目录是 /etc/nginx/http.d/default.conf

SHELL ["/bin/bash", "-c"]
# Use bash shell
ENV SHELL=/bin/bash

#RUN chmod +x /start.sh
ENV PORT=80
ENV START_DIR=/home/Projects
EXPOSE 80
ENTRYPOINT ["/start.sh"]
