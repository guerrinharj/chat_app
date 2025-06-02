#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    echo "Ambiente: production"
    cp .env.production .env
    RAILS_ENV="production"
else
    echo "Ambiente: development"
    cp .env.development .env
    RAILS_ENV="development"
fi

set -a
source .env
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
