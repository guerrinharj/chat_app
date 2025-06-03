# CHAT APP

## Versões :gem:
* **Ruby:** 3.3.1
* **Rails:** 7.1.5

## Docker :whale:

<p>Essa é uma aplicação 100% dockerizada</p>

#### Instale Docker para Mac
<ul>
    <li>Instale Docker Desktop: https://docs.docker.com/desktop/install/mac-install </li>
</ul>

#### Instale Docker parafor Linux
<ul>
    <li>Desinstale docker engine: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine</li>
    <li>Instale docker engine: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository</li>
    <li>Configure docker como non-root user: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user</li>
    <li>Configure docker para startar no boot: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot</li>
</ul>

#### Instale Docker para Windows
<ul>
    <li>Você ? Docker não funciona bem com Windows. </li>
</ul>

#### Lembretes de passos com Docker

- Certifique-se de que as permissões do seu sistema operacional e terminal estejam corretas. (Não tenha medo de alterar o shebang caso necessário)
- Certifique-se de que cada um dos seus `.env` hosts esteja definido como `db`
- Seu `user` e `password` virão das variáveis no `.env`
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