#!/bin/sh

# Exit on errors
set -e

# Determine the environment
if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
else
    ENV_FILE="./.env.development"
fi

echo "Loading environment from $ENV_FILE"

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