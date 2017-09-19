#!/bin/bash

# When the main application directory is a mount we assume we're in a development
# environment and adjust the permissions of the running processes to match the users
# directory to avoid permission errors.

if mount | grep /application > /dev/null; then
    usermod  -u `stat -c '%u' /application` www-data
    groupmod -g `stat -c '%g' /application` www-data
fi

# Apply runtime configuration

APP_NAME=${APP_NAME:-'example'}
APP_CONF=${APP_CONF:-'---'}

echo "$APP_CONF" > /ansible/override.yaml

cd /ansible \
  && ansible-playbook \
       -e "{ application: { name: $APP_NAME } }" \
       -e "@/ansible/override.yaml" \
       --tags="configuration" \
       site.yml

# Cleanup

rm -f /ansible/override.yaml

# Start

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf