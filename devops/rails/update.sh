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

echo "Executando migrações no banco de dados para $RAILS_ENV..."
docker compose run web rails db:migrate RAILS_ENV=$RAILS_ENV


if [ "$1" != "production" ]; then
    echo "Running RSpec tests..."
    docker compose run web rspec
fi

echo "Removendo containers parados..."
docker container prune -f

echo "Atualização finalizada para $RAILS_ENV."
