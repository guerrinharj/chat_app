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

echo "Running in $RAILS_ENV environment."

chmod +x ./devops/compose/exec.sh

echo "Starting an interactive shell in the web container."
docker compose exec web bash

echo "Installing gems in the web container..."
docker compose exec web bash -c "bundle install"

