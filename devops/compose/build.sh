#!/bin/sh

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

chmod +x ./devops/compose/build.sh

echo "Buildando Docker ..."
docker compose build


echo "Rodando bundle install no service web..."
docker compose run web bundle install


echo "Configurando RSpec..."
docker compose run web rails generate rspec:install