FROM dockurr/samba

# Add envsubst or any tools you want
RUN apk add --no-cache gettext

# Add your optional auto-user entrypoint
COPY app/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
