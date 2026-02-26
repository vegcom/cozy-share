FROM dockurr/samba

COPY app/entrypoint.sh /entrypoint.sh
COPY app/avahi/services/*.service /etc/avahi/services/

RUN apk add --no-cache wsdd avahi tini && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

EXPOSE 137/udp 138/udp 139/tcp 3702/udp 445/tcp 5353/udp