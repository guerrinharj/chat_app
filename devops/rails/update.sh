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

echo "Executando migrações no banco de dados para $RAILS_ENV..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:migrate

if [ "$RAILS_ENV" != "production" ]; then
    echo "Running RSpec tests..."
    docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rspec
fi

echo "Removendo containers parados..."
docker container prune -f

echo "Atualização finalizada para $RAILS_ENV."
