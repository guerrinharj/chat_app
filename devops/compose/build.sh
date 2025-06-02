#!/bin/sh

# Exit on errors
set -e

# Determine the environment
if [ "$1" = "production" ]; then
    RAILS_ENV="./.env.production"
else
    RAILS_ENV="./.env"
fi

echo "Loading environment from $RAILS_ENV"

set -a
. "$RAILS_ENV"
set +a

chmod +x ./devops/compose/build.sh

echo "Buildando Docker ..."
docker compose build


echo "Rodando bundle install no service web..."
docker compose run web bundle install


echo "Configurando RSpec..."
docker compose run web rails generate rspec:install