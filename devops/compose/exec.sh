#!/bin/sh

set -e

if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
else
    ENV_FILE="./.env.development"
fi

set -a
. "$ENV_FILE"
set +a

echo "Ambiente $RAILS_ENV "

chmod +x ./devops/compose/exec.sh

echo "Abrindo shell do web container..."
docker compose exec web bash
