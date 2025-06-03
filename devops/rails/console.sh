#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

set -a
. "$ENV_FILE"
set +a

echo "Abrindo console Rails para o ambiente $RAILS_ENV..."
docker compose exec -e RAILS_ENV=$RAILS_ENV web rails c
