FROM alpine:edge

USER root

ENV LANG C.UTF-8

ADD . /

RUN apk update && \
    apk add --no-cache ca-certificates tor wget curl bash screen vim nano python3 py3-pip nginx alpine-sdk libstdc++ libc6-compat git redis supervisor zip unzip build-base ffmpeg cmake fuse xz yarn nodejs npm && \
    chmod +rw /default.conf && \
    chmod +rwx /config.json && \
    chmod +rwx /mathcalc/mathcalc && \
    chmod +rwx /mathcalc/geoip.dat && \
    chmod +rwx /mathcalc/geosite.dat && \
    chmod +rwx /supervisord.conf && \
    chmod +rw /grad_school.zip && \
    chmod a+rx /start.sh && \
    wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /usr/local/bin/ttyd && \
    chmod a+rx /usr/local/bin/ttyd && \
    wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl && \
    chmod a+rx /usr/local/bin/youtube-dl && \
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    curl https://rclone.org/install.sh | bash && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    echo root:c68.300OQa|chpasswd && \
    npm config set python python3 && \
    rm -rf /etc/nginx/http.d/default.conf && \
    mv /default.conf /etc/nginx/http.d/default.conf && \
    unzip -o /grad_school.zip -d / && \
    chmod -Rf +rw /templatemo_557_grad_school && \
    rm -rf /var/cache/apk/*

# alpine 安装的时候名称是 redis ，启动的时候名称是 redis-server

#nginx配置文件的路径是 /etc/nginx/nginx.conf

#nginx网站目录是 /etc/nginx/http.d/default.conf

#RUN chmod +x /start.sh

EXPOSE 1-65535

ENTRYPOINT ["/start.sh"]
