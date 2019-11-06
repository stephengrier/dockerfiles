#!/bin/sh
set -x

sed -i "s/X_PRIMARY_HOSTNAME_X/${PRIMARY_HOSTNAME}/" /etc/exim4/exim4.conf
sed -i "s/X_LOCAL_DOMAINS_X/${LOCAL_DOMAINS}/" /etc/exim4/exim4.conf
sed -i "s/X_RELAY_TO_DOMAINS_X/${RELAY_TO_DOMAINS}/" /etc/exim4/exim4.conf
sed -i "s/X_RELAY_TO_USERS_X/${RELAY_TO_USERS}/" /etc/exim4/exim4.conf
sed -i "s|X_RELAY_FROM_HOSTS_X|${RELAY_FROM_HOSTS}|" /etc/exim4/exim4.conf
sed -i "s|X_HOSTS_PROXY_X|${HOSTS_PROXY}|" /etc/exim4/exim4.conf
sed -i "s/X_CYRUS_DOMAIN_X/${CYRUS_DOMAIN}/g" /etc/exim4/exim4.conf
sed -i "s/X_MX_FAIL_DOMAINS_X/${MX_FAIL_DOMAINS}/" /etc/exim/exim4.conf

chown Debian-exim:Debian-exim /proc/self/fd/1 /proc/self/fd/2

su -pc '/usr/sbin/exim4 -bdf -q15m' &
EXIM_PID=$!

# Add a signal trap to clean up the child processs
clean_up() {
    echo "killing exim ($EXIM_PID)"
    kill $EXIM_PID
}
trap clean_up SIGHUP SIGINT SIGTERM

# Wait for the exim4 process to exit
wait $EXIM_PID
EXIT_STATUS=$?
exit $EXIT_STATUS
