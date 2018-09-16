#!/bin/bash
# ----------------------------------------------------------------------
# Create a dummy certificate if none is available
# ----------------------------------------------------------------------
if [ ! -f /etc/ssl/ssl.key ]
then
  openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -keyout /etc/ssl/ssl.key -out /etc/ssl/ssl.pem -days 3650
fi

# ----------------------------------------------------------------------
# Create the .env file if it does not exist.
# ----------------------------------------------------------------------

if [[ ! -f "/var/www/.env" ]] && [[ -f "/var/www/.env.example" ]];
then
  cp /var/www/.env.example /var/www/.env
fi

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------

if [[ ! -d "/var/www/vendor" ]];
then
  cd /var/www
  composer update
  composer dump-autoload -o
fi

# ----------------------------------------------------------------------
# Start supervisord
# ----------------------------------------------------------------------

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
