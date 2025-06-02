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

echo "Subindo containers..."
docker compose down -v
docker compose up -d --build

echo "Instalando gems..."
docker compose run --rm web bundle install

echo "Resetando banco de dados..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web rails db:drop
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:create

echo "Executando migrações..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:migrate

echo "Executando seed inicial..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:seed

echo "✅ Banco de dados reiniciado com sucesso para $RAILS_ENV."
