# CANAL DE MENSAGENS / CHAT APP 

### Sobre o Backend (API Rails)

O backend desta aplicação foi desenvolvido em **Ruby on Rails** como parte do desafio da [NewByte](https://github.com/newbytesolucoesdigitais/desafio). Ele oferece uma **API RESTful** para autenticação de usuários, além de um **canal WebSocket em tempo real** via **ActionCable** para troca de mensagens no chat.

#### Funcionalidades principais

- **Cadastro e login de usuários**
  - Cadastro de novos usuários via API
  - Simulação de confirmação de e-mail
  - Login com `username` ou `email` e senha
  - Geração de `session_token` para autenticação

- **Autenticação baseada em token**
  - O `session_token` é enviado como parâmetro ao se conectar via WebSocket
  - A conexão é rejeitada se o token for inválido

- **Canal de chat em tempo real (`ChatChannel`)**
  - Assinatura via WebSocket (ActionCable)
  - Ação `speak` envia mensagens para o servidor
  - Cada mensagem é salva no banco com o usuário associado
  - As mensagens são transmitidas em tempo real para todos os clientes conectados

- 📄 **Listagem de mensagens**
  - As mensagens podem ser acessadas via endpoint REST
  - Ordenação por data de criação (mais recentes primeiro)

#### 📁 Repositório do frontend

Você pode acessar o código-fonte do frontend aqui:  
👉 [github.com/guerrinharj/chat_app](https://github.com/guerrinharj/chat-app-vue)


## Versões :gem:
* **Ruby:** 3.3.1
* **Rails:** 7.1.5

## Docker :whale:

<p>Essa é uma aplicação 100% dockerizada</p>

#### Instale Docker para Mac
<ul>
    <li>Instale Docker Desktop: https://docs.docker.com/desktop/install/mac-install </li>
</ul>

#### Instale Docker para Linux
<ul>
    <li>Desinstale docker engine: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine</li>
    <li>Instale docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository</li>
    <li>Configure docker como non-root user: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user</li>
    <li>Configure docker para startar no boot: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot</li>
</ul>

#### Lembretes de passos com Docker

- Este repositorio usa shell scripts (encontrados na pasta ```devops```para facilitar operação de diversos comandos) 
- Certifique-se de que as permissões do seu sistema operacional e terminal estejam corretas. (Não tenha medo de alterar o shebang caso necessário)
- Certifique-se de que cada um dos seus `.env` hosts esteja definido como `db`
- Se você estiver carregando as variáveis de ambiente a partir do `.env.production`, você pode sempre escrever `"production"` após os scripts shell.
- Se não for a primeira instalação, **não sobrescreva arquivos**
- Se estiver instalando uma nova gem, sempre tenha certeza de **rebuildar**
- Certifique-se que o seu browser não esteja forçando HTTPS ou SSL.



### Builda o container e começa uma nova DB


```bash
cd chat_app
  sh devops/chmod.sh
  ./devops/compose/build.sh --no-cache
  ./devops/compose/up.sh
  ./devops/rails/restart.sh
  ./devops/compose/exec.sh
        bundle
        rspec
        exit
  ./devops/compose/down.sh
  exit
```

### Rails console

```bash
cd chat_app
    ./devops/compose/up.sh
    ./devops/rails/console.sh
    # CTRL + C
    ./devops/compose/down.sh
  exit
```


### Rodar Rails server

```bash
cd chat_app
    ./devops/compose/up.sh
    ./devops/rails/server.sh
    # CTRL + C
    ./devops/compose/down.sh
  exit
```

### Rodar novas migrações  DB and Rails

```bash
cd chat_app
    ./devops/compose/up.sh
    ./devops/rails/update.sh
    ./devops/compose/down.sh
  exit
```

### Desinstalar

- Esses scripts não são necessarios o uso do da variavel `production`

```bash
cd chat_app
  ./devops/compose/down.sh
  ./devops/compose/delete.sh
  exit
```


## Caso esteja rodando localmente a API :monorail:

0. Clone este repositório.
1. Rode `bundle install` para instalar todas as dependências do projeto.
2. Crie os arquivos `.env.development`, `.env.test` e `.env.production` (caso vá fazer deploy), de acordo com o seu `config/database.yml`.
3. Rode `rails db:create db:migrate db:seed` para criar o banco de dados, rodar as migrações e popular com dados iniciais.
4. Rode `rspec` para executar os testes.
5. Rode `rails s` e acesse via `localhost:3000`.


## Lembretes sobre o Banco de Dados

- Se estiver tendo problemas ao abrir em um gerenciador de banco de dados (como Beekeeper, DBeaver, PG Admin, etc.), não se esqueça de que é necessário rodar o container e usar `localhost` como host.
- Se aparecerem erros relacionados a permissões (roles), não tenha medo de rodar `pkill postgres` e `brew services stop postgresql` (caso esteja usando o Homebrew).
- Se estiver com problemas de acesso de usuários ao banco, tente rebuildar o container.


## Request cURLs

- Usa a pasta `discovery` para pegar exemplos de cURLs.