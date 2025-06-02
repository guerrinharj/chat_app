#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    RAILS_ENV="./.env.production"
else
    RAILS_ENV="./.env"
fi

echo "Loading environment from $RAILS_ENV"

set -a
. "$RAILS_ENV"
set +a

echo "Abrindo console para $RAILS_ENV..."
docker compose exec -e RAILS_ENV=$RAILS_ENV web rails c
