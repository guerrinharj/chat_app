#!/bin/sh

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

chmod +x ./devops/compose/up.sh

echo "Limpando Docker containers inativos..."
docker container prune -f

echo "Iniciando Docker containers..."
docker compose up -d

echo "Docker containers estão inicializados no ambiente $RAILS_ENV e rodando no port ${CHAT_APP_PORT}."
