#!/bin/sh
set -x

sed -i "s/X_PRIMARY_HOSTNAME_X/${PRIMARY_HOSTNAME}/" /etc/exim/exim.conf
sed -i "s/X_LOCAL_DOMAINS_X/${LOCAL_DOMAINS}/" /etc/exim/exim.conf
sed -i "s/X_RELAY_TO_DOMAINS_X/${RELAY_TO_DOMAINS}/" /etc/exim/exim.conf
sed -i "s/X_RELAY_TO_USERS_X/${RELAY_TO_USERS}/" /etc/exim/exim.conf
sed -i "s|X_RELAY_FROM_HOSTS_X|${RELAY_FROM_HOSTS}|" /etc/exim/exim.conf
sed -i "s/X_CYRUS_DOMAIN_X/${CYRUS_DOMAIN}/g" /etc/exim/exim.conf

chown exim:exim /proc/self/fd/1

su -pc '/usr/sbin/exim -bdf -q15m' &
EXIM_PID=$!

# Add a signal trap to clean up the child processs
clean_up() {
    echo "killing exim ($EXIM_PID)"
    kill $EXIM_PID
}
trap clean_up SIGHUP SIGINT SIGTERM

# Wait for the exim process to exit
wait $EXIM_PID
EXIT_STATUS=$?
exit $EXIT_STATUS
