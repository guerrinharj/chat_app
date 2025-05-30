#!/bin/sh

# Exit on errors
set -e

# Determine the environment
if [ "$1" = "production" ]; then
    ENV_FILE="./.env.production"
else
    ENV_FILE="./.env.development"
fi

echo "Loading environment from $ENV_FILE"

set -a
. "$ENV_FILE"
set +a

chmod +x ./devops/compose/build.sh

echo "Building Docker images..."
docker compose build


echo "Running bundle install in the web service..."
docker compose run web bundle install


echo "Generating RSpec configuration..."
docker compose run web rails generate rspec:install


echo "Running Devise install (only if not already installed)..."
docker compose run --rm web test -f config/initializers/devise.rb || docker compose run --rm web rails generate devise:install