FROM dockurr/samba

COPY app/entrypoint.sh /entrypoint.sh
COPY app/avahi/services/*.service /etc/avahi/services/

RUN apk add --no-cache wsdd avahi tini && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
