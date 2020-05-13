#!/bin/bash
set -e

if [[ -z "${ENVIRONMENT}" ]]; then
    echo "Tipo de Ambiente: DEV"

    echo "> Migrating Database"
    bundle exec rake db:migrate

    echo "> Populating Database"
    bundle exec rails db:seed

    echo "> Clear tmp"
    rm -f /app/tmp/pids/server.pid
    rm -rf /app/tmp/cache/assets/sprockets/

    bundle exec rake cache:fetch

    echo "> Running server"
    bundle exec rails server -b 0.0.0.0 -p 3000
else
    echo "Tipo de Ambiente: ${ENVIRONMENT}"
    rm -rf /app/tmp/cache/assets/sprockets/
fi
