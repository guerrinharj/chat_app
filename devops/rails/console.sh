#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    echo "Ambiente: production"
    cp .env.production .env
    export RAILS_ENV="production"
else
    echo "Ambiente: development"
    cp .env.development .env
    export RAILS_ENV="development"
fi

set -a
source .env
set +a

echo "Abrindo console para $RAILS_ENV..."
docker compose exec -e RAILS_ENV=$RAILS_ENV web rails c
