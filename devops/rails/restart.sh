#!/bin/zsh

set -e

# Define ambiente e arquivo .env
if [ "$1" = "production" ]; then
    echo "Ambiente: production"
    ENV_FILE=".env.production"
    RAILS_ENV="production"
else
    echo "Ambiente: development"
    ENV_FILE=".env.development"
    RAILS_ENV="development"
fi

# Carrega variáveis do .env para o shell
set -a
source "$ENV_FILE"
set +a

echo "Instalando gems..."
bundle install
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web bundle install

echo "Resetando banco de dados..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web rails db:drop
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:create

echo "Gerando model Usuario..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails generate model Usuario nome:string username:string email:string password_digest:string

echo "Gerando model Mensagem..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails generate model Mensagem texto:text usuario:references

echo "Executando migrações..."
docker compose run --rm -e RAILS_ENV=$RAILS_ENV web rails db:migrate

echo "Banco de dados reiniciado com sucesso para $RAILS_ENV."
