#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

echo "Ambiente $ENV_FILE"

set -a
. "$ENV_FILE"
set +a


chmod +x ./devops/rails/console.sh

docker compose exec web rails c