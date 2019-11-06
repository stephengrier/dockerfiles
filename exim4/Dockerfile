FROM ubuntu:rolling

RUN apt-get update && \
    apt-get -y install exim4-daemon-heavy && \
    mkdir -p /var/log/exim4 /var/spool/exim4 /usr/lib/exim4 /etc/exim4/virtualdomains && \
    ln -sf /dev/stdout /var/log/exim4/mainlog && \
    ln -sf /dev/stderr /var/log/exim4/panic && \
    ln -sf /dev/stderr /var/log/exim4/reject && \
    chown -R Debian-exim:Debian-exim /var/log/exim4 /var/spool/exim4 /usr/lib/exim4 && \
    chmod 0755 /usr/sbin/exim4 && \
    sed -i 's|/var/spool/exim4:/usr/sbin/nologin|/var/spool/exim4:/bin/bash|' /etc/passwd

COPY exim.conf /etc/exim4/exim4.conf
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
