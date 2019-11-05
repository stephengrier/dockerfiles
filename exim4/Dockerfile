FROM alpine:3.10

RUN apk --no-cache add exim && \
    mkdir -p /var/log/exim /var/spool/exim /usr/lib/exim /etc/exim/virtualdomains && \
    ln -sf /dev/stdout /var/log/exim/mainlog && \
    ln -sf /dev/stderr /var/log/exim/panic && \
    ln -sf /dev/stderr /var/log/exim/reject && \
    chown -R exim:exim /var/log/exim /var/spool/exim /usr/lib/exim && \
    chmod 0755 /usr/sbin/exim && \
    sed -i 's|/var/spool/exim:/sbin/nologin|/var/spool/exim:/bin/ash|' /etc/passwd

COPY exim.conf /etc/exim/exim.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8025

ENV LOCAL_DOMAINS=@ \
    PRIMARY_HOSTNAME= \
    RELAY_FROM_HOSTS=10.0.0.0/8:172.16.0.0/12:192.168.0.0/16 \
    RELAY_TO_DOMAINS=* \
    RELAY_TO_USERS= \
    SMARTHOST= \
    SMTP_PASSWORD= \
    SMTP_USERDOMAIN= \
    SMTP_USERNAME= \
    CYRUS_DOMAIN= \
    HOSTS_PROXY= \
    MX_FAIL_DOMAINS=

ENTRYPOINT ["/start.sh"]
