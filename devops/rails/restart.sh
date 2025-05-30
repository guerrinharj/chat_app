#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    echo "⚙️  Ambiente: production"
    ENV_FILE=".env.production"
    RAILS_ENV="production"
else
    echo "⚙️  Ambiente: development"
    ENV_FILE=".env.development"
    RAILS_ENV="development"
fi

set -a
source "$ENV_FILE"
set +a

echo "Limpando banco de dados anterior..."
rm -f db/schema.rb
find db/migrate -name '*usuario*.rb' -delete
find db/migrate -name '*mensagem*.rb' -delete


echo "Resetando banco de dados..."
docker compose exec web rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1
docker compose exec web rails db:create


echo "Gerando Usuario..."
docker compose exec web rails generate model Usuario nome:string username:string email:string password_digest:string

echo "Gerando Mensagem..."
docker compose exec web rails generate model Mensagem texto:text usuario:references

echo "Migrando models..."
docker compose exec web rails db:migrate

echo "Banco de dados reiniciado com sucesso para $RAILS_ENV."
