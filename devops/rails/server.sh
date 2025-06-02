#!/bin/zsh

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

chmod +x ./devops/rails/server.sh

rm -rf tmp/pids

docker compose exec web bundle exec rails s -b '0.0.0.0' -p ${CHAT_APP_PORT:-3000}
