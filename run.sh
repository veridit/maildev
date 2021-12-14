#!/bin/ash
#
/usr/sbin/dovecot &

/usr/sbin/exim &

while true; do sleep 1; done