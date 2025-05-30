#!/bin/zsh

# Exit on any error
set -e

# Choose environment
if [ "$1" = "production" ]; then
  echo "Setting up the production environment..."
  ENV_FILE=".env.production"
  RAILS_ENV="production"
else
  echo "Setting up the development environment..."
  ENV_FILE=".env.development"
  RAILS_ENV="development"
fi

# Load environment variables
set -a
. "$ENV_FILE"
set +a


echo "Recreating database..."
docker compose exec web bundle exec rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1
docker compose exec web bundle exec rails db:create
docker compose exec web bundle exec rails db:migrate


if ! docker compose exec web test -f app/models/usuario.rb; then
    echo "Generating Usuario model with Devise..."
    docker compose exec web rails generate devise Usuario
    docker compose exec web rails generate migration AddNomeAndUsernameToUsuarios nome:string username:string:uniq
    docker compose exec web rails db:migrate
fi

if [ "$RAILS_ENV" = "development" ]; then
    echo "Running RSpec tests..."
    docker compose run --rm rspec
fi

# Clean up stopped containers
echo "Pruning stopped containers..."
docker container prune -f

echo "✅ Restart complete for $RAILS_ENV."
