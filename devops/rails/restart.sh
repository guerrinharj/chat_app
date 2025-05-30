#!/bin/zsh

set -e

if [ "$1" = "production" ]; then
    echo "Ambiente: production"
    ENV_FILE=".env.production"
    RAILS_ENV="production"
else
    echo "Ambiente: development"
    ENV_FILE=".env.development"
    RAILS_ENV="development"
fi

set -a
source "$ENV_FILE"
set +a

echo "Limpando banco de dados e arquivos antigos..."
rm -f db/schema.rb
find db/migrate -name '*usuario*.rb' -delete
find db/migrate -name '*mensagem*.rb' -delete
rm -f app/models/usuario.rb
rm -f app/models/mensagem.rb
rm -f app/controllers/usuarios_controller.rb
rm -f app/controllers/mensagens_controller.rb
rm -rf app/views/usuarios
rm -rf app/views/mensagens

echo "Resetando banco de dados..."
docker compose exec web rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1
docker compose exec web rails db:create

echo "Gerando model Usuario..."
docker compose exec web rails generate model Usuario nome:string username:string email:string password_digest:string

echo "Gerando model Mensagem..."
docker compose exec web rails generate model Mensagem texto:text usuario:references

echo "Executando migrações..."
docker compose exec web rails db:migrate

echo "Banco de dados reiniciado com sucesso para $RAILS_ENV."
