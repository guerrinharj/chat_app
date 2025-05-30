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

chmod +x ./devops/compose/down.sh

echo "Stopping and removing Docker containers..."
docker compose down --remove-orphans

echo "All services have been stopped and removed."
