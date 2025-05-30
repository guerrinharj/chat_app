#!/bin/sh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
else
    ENV_FILE="./.env.development"
fi

echo "Ambiente $ENV_FILE"

set -a
. "$ENV_FILE"
set +a

chmod +x ./devops/compose/delete.sh

echo "Parando e removendo Docker containers..."
docker compose down --remove-orphans --volumes --rmi=all

echo "Todos services foram parados e removidos."
