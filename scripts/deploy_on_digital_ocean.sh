#!/bin/bash

# This script will quit on the first error that is encountered.
set -e

CIRCLE=$1

DEPLOY_DATE=`date "+%FT%T%z"`
SECRET=$(openssl rand -base64 58 | tr '\n' '_')

heroku config:set --app=eggtimer \
NEW_RELIC_APP_NAME='eggtimer' \
ADMIN_EMAIL="egg.timer.app@gmail.com" \
ADMIN_NAME="egg timer" \
DJANGO_SETTINGS_MODULE=eggtimer.settings \
DJANGO_SECRET_KEY="$SECRET" \
DEPLOY_DATE="$DEPLOY_DATE" \
> /dev/null

if [ $CIRCLE ]
then
    echo "Push is handled by circle heroku orb"
else
    git push heroku master
fi

heroku run python manage.py collectstatic --noinput
heroku run python manage.py migrate --noinput --app eggtimer
