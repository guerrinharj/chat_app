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

echo "Ambiente $ENV_FILE"

set -a
. "$ENV_FILE"
set +a


chmod +x ./devops/rails/console.sh

docker compose exec web rails c