#!/bin/sh

set -e

if [ "$1" = "production" ]; then
    RAILS_ENV="./.env.production"
else
    RAILS_ENV="./.env"
fi

set -a
. "$RAILS_ENV"
set +a

echo "Ambiente $RAILS_ENV "

chmod +x ./devops/compose/exec.sh

echo "Abrindo shell do web container..."
docker compose exec web bash
