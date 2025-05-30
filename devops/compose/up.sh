#!/bin/sh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
else
    ENV_FILE="./.env.development"
fi

echo "Loading environment from $ENV_FILE"

set -a
. "$ENV_FILE"
set +a

chmod +x ./devops/compose/up.sh

echo "Limpando Docker containers inativos..."
docker container prune -f

echo "Iniciando Docker containers..."
docker compose up -d

echo "Docker containers estão inicializados no ambiente $ENV_FILE e rodando no port ${CHAT_APP_PORT}."
