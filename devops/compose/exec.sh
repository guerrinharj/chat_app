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

chmod +x ./devops/compose/exec.sh

echo "Abrindo shell em ambiente $RAILS_ENV do web container..."
docker compose exec web bash
