#!/bin/zsh

set -e

# Define environment and .env file
if [ "$1" = "production" ]; then
    echo "Ambiente: production"
    ENV_FILE=".env.production"
    RAILS_ENV="production"
else
    echo "Ambiente: development"
    ENV_FILE=".env.development"
    RAILS_ENV="development"
fi

# Load env variables
set -a
source "$ENV_FILE"
set +a

echo "Instalando gems..."
bundle install
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web bundle install

echo "Resetando banco de dados..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web rails db:drop
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:create

echo "Executando migrações..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:migrate

echo "Executando seed inicial..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:seed

echo "✅ Banco de dados reiniciado com sucesso para $RAILS_ENV."
