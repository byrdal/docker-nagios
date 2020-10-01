#!/bin/bash -e

NAGIOS_BASIC_AUTH=${NAGIOS_BASIC_AUTH:-enabled}
NAGIOS_USER=${NAGIOS_USER:-nagiosadmin}
NAGIOS_PASS=${NAGIOS_PASS:-nagiosadmin}
NAGIOS_TIMEZONE=${NAGIOS_TIMEZONE:-UTC}

echo "fastcgi_param TZ ${NAGIOS_TIMEZONE};" > /etc/nginx/timezone-include.conf

/etc/init.d/postfix start
/etc/init.d/php7.4-fpm start
/etc/init.d/fcgiwrap start
/etc/init.d/nginx start

if [ "${NAGIOS_BASIC_AUTH}" = "enabled" ]
then
  htpasswd -cb /etc/nginx/.htpasswd ${NAGIOS_USER} ${NAGIOS_PASS}
else
  > /etc/nginx/basic-auth-include.conf
fi

mkdir -p /usr/local/nagios/var
mkdir -p /usr/local/nagiosgraph/var/log

chown nagios:nagios -R /usr/local/nagios
chown nagios:nagios -R /usr/local/nagiosgraph
chown nagios:nagios -R /home/nagios

echo "use_timezone=${NAGIOS_TIMEZONE}" >> /usr/local/nagios/etc/nagios.cfg

/usr/local/nagios/bin/nagios /usr/local/nagios/etc/nagios.cfg &

function shutdown() {
  kill -TERM ${!}
  wait

  sleep 1
}
trap shutdown SIGTERM SIGHUP SIGINT

wait

shutdown
