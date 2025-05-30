#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    echo "Ambiente: production"
    ENV_FILE=".env.production"
    RAILS_ENV="production"
else
    echo "Ambiente: development"
    ENV_FILE=".env.development"
    RAILS_ENV="development"
fi

set -a
source "$ENV_FILE"
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
