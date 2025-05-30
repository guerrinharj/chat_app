#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    echo "Setting up the production environment..."
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    echo "Setting up the development environment..."
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

set -a
. "$ENV_FILE"
set +a

chmod +x ./devops/rails/update.sh

echo "Running database commands for $RAILS_ENV..."
docker compose run web rails db:migrate RAILS_ENV=$RAILS_ENV


if [ "$1" != "production" ]; then
    echo "Running RSpec tests..."
    docker compose run web rspec
fi

echo "Pruning stopped containers..."
docker container prune -f

echo "Done."
