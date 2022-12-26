FROM alpine:latest

USER root

# Create a group and user
# RUN addgroup -S euler && adduser -S euler -G euler
# install usermod apk add shadow
RUN apk add --no-cache --no-progress shadow bash && \
    addgroup euler && \
    adduser -G euler -s /bin/bash -D euler && \
    mkdir -p /home/euler/.local && \
    chown -R euler:euler /home/euler && \
    chown -R euler:euler /home/euler/.local && \
    usermod -a -G root euler && \
    adduser euler abuild

# Tell docker that all future commands should run as the appuser user
USER euler

ENV TZ="Asia/Shanghai"
ENV LANG C.UTF-8

WORKDIR /app

ADD . /app/

RUN apk update && \
    apk add --no-cache --no-progress ca-certificates tor wget curl vim nano screen python3 py3-pip nginx alpine-sdk libstdc++ libc6-compat libx11-dev libxkbfile-dev libsecret-dev libwebsockets-dev git redis supervisor zip unzip build-base ffmpeg cmake fuse xz yarn nodejs npm gnupg openssh-client gcompat qbittorrent-nox musl-dev tzdata autoconf automake openssh mingw-w64-gcc aria2 coreutils openjdk11 ttyd libwebsockets-evlib_uv libuv json-c-dev

# fonts https://wiki.alpinelinux.org/wiki/Fonts
RUN apk add --no-cache --no-progress msttcorefonts-installer terminus-font ttf-inconsolata ttf-dejavu font-noto font-noto-cjk ttf-font-awesome font-noto-extra font-vollkorn font-misc-cyrillic font-mutt-misc font-screen-cyrillic font-winitzki-cyrillic font-cronyx-cyrillic terminus-font font-noto font-noto-thai font-noto-tibetan font-ipa font-sony-misc font-daewoo-misc font-jis-misc font-isas-misc terminus-font font-noto font-noto-extra font-arabic-misc font-misc-cyrillic font-mutt-misc font-screen-cyrillic font-winitzki-cyrillic font-cronyx-cyrillic font-noto-arabic font-noto-armenian font-noto-cherokee font-noto-devanagari font-noto-ethiopic font-noto-georgian font-noto-hebrew font-noto-lao font-noto-malayalam font-noto-tamil font-noto-thaana font-noto-thai

RUN fc-cache -fv

RUN apk add --no-cache --no-progress chromium chromium-chromedriver chromium-swiftshader nss freetype harfbuzz ttf-freefont xvfb-run fontconfig pango-dev libxcursor libxdamage cups-libs dbus-libs libxrandr libxscrnsaver udev xauth dumb-init linux-headers binutils-gold

USER euler

SHELL ["/bin/bash", "-c"]
# Use bash shell
ENV SHELL=/bin/bash

RUN npm install -g wstunnel && \
    npm install -g koa-generator && \
    npm install -g pm2 && \
    npm install -g nodemon && \
    npm install -g typescript && \
    npm install -g @angular/cli && \
    chmod +rw /app/default.conf && \
    chmod +rwx /app/config.json && \
    chmod +rwx /app/mathcalc/mathcalc && \
    chmod +rwx /app/mathcalc/geoip.dat && \
    chmod +rwx /app/mathcalc/geosite.dat && \
    chmod +rwx /app/supervisord.conf && \
    chmod +rw /app/grad_school.zip && \
    chmod +rwx /app/start.sh && \
    chmod +rwx /app/math_config.sh && \
    chmod +rwx /app/Keep_Alive.sh && \
    chmod +rwx /app/aria2.conf && \
    # wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /usr/local/bin/ttyd && \
    # chmod a+rwx /usr/local/bin/ttyd && \
    wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl && \
    chmod a+rwx /usr/local/bin/youtube-dl && \
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    curl https://rclone.org/install.sh | bash && \
    rm -rf /usr/bin/python && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp && \
    pip3 install you-get && \
    rm -rf /root/.bashrc && \
    cp /app/.bashrc /root/.bashrc && \
    cp /app/.bashrc /home/euler/.bashrc && \
    rm -rf /app/.bashrc && \
    echo root:c68.300OQa|chpasswd && \
    echo euler:c68.300OQa|chpasswd && \
    rm -rf /etc/nginx/http.d/default.conf && \
    mv /app/default.conf /etc/nginx/http.d/default.conf && \
    unzip -o /app/grad_school.zip -d /app/ && \
    rm -rf /app/grad_school.zip && \
    chmod -Rf +rw /app/templatemo_557_grad_school && \
    chmod +rwx /app/actboy168.tasks-0.11.1.vsix && \
    cp "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" >  /etc/timezone && \
    rm -rf /app/.git && \
    rm -rf /var/cache/apk/*

# alpine 安装的时候名称是 redis ，启动的时候名称是 redis-server

#nginx配置文件的路径是 /etc/nginx/nginx.conf

#nginx网站目录是 /etc/nginx/http.d/default.conf

#RUN chmod +x /start.sh
ENV PORT=80
ENV START_DIR=/home/Projects
EXPOSE 80

RUN /app/start.sh
RUN /app/math_config.sh
ENTRYPOINT ["/app/Keep_Alive.sh"]
