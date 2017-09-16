#!/bin/bash

# When the main application directory is a mount we assume we're in a development
# environment and adjust the permissions of the running processes to match the users
# directory to avoid permission errors.

if mount | grep /var/www/application > /dev/null; then
    usermod  -u `stat -c '%u' /var/www/application` www-data
    groupmod -g `stat -c '%g' /var/www/application` www-data
fi

# Apply runtime configuration

APP_NAME=${APP_NAME:-'example'}
APP_CONF=${APP_CONF:-'{}'}

cd /ansible \
  && ansible-playbook \
       -e "{ application: { name: $APP_NAME } }" \
       -e "{ khaos: $APP_CONF }" \
       --tags="run,development,configuration" \
       site.yml

# Start

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf