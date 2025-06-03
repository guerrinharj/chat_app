#!/bin/sh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

set -a
. "$ENV_FILE"
set +a

chmod +x ./devops/compose/up.sh

echo "Limpando Docker containers inativos..."
docker container prune -f

echo "Iniciando Docker containers..."
docker compose up -d

echo "Docker containers estão inicializados no ambiente $RAILS_ENV e rodando no port ${CHAT_APP_PORT}."
