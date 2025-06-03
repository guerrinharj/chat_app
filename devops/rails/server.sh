#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

echo "Ambiente: $RAILS_ENV"

set -a
. "$ENV_FILE"
set +a

rm -rf tmp/pids

docker compose exec -e RAILS_ENV=$RAILS_ENV web bundle exec rails s -b '0.0.0.0' -p ${CHAT_APP_PORT:-3000}
