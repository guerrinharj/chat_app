#!/bin/zsh

# Exit on errors
set -e

# Determine the environment
if [ "$1" = "production" ]; then
    echo "Setting up the production environment..."
    ENV_FILE="./.env.production"
    RAILS_ENV="production"
else
    echo "Setting up the development environment..."
    ENV_FILE="./.env.development"
    RAILS_ENV="development"
fi

# Load environment variables
set -a
. "$ENV_FILE"
set +a

# Grant execute permissions
chmod +x ./devops/rails/restart.sh

# Install gems
echo "Installing gems..."
bundle install
docker compose exec web bundle install
docker compose exec web rails generate devise:install

echo "Running database commands for $RAILS_ENV..."
docker compose run -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web rails db:drop RAILS_ENV=$RAILS_ENV 
docker compose run web rails db:create RAILS_ENV=$RAILS_ENV
docker compose exec web rails generate devise Usuario RAILS_ENV=$RAILS_ENV
docker compose exec web rails generate migration AddNomeAndUsernameToUsuarios nome:string username:string:uniq
docker compose exec web rails db:migrate




# Run RSpec tests
if [ "$1" != "production" ]; then
    echo "Running RSpec tests..."
    docker compose run web rspec
fi

# Clean up
echo "Pruning stopped containers..."
docker container prune -f

echo "Done."
