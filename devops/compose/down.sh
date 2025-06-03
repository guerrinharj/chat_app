#!/bin/sh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

echo "Ambiente $RAILS_ENV"

set -a
. "$RAILS_ENV"
set +a

chmod +x ./devops/compose/down.sh

echo "Parando e removendo Docker containers..."
docker compose down --remove-orphans

echo "Todos services foram parados e removidos."
