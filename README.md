# Proxy Dev

Ambiente local de desenvolvimento com Docker Compose para subir rapidamente serviços de infraestrutura usados no dia a dia. Centraliza banco de dados, cache, envio de emails para testes e proxy web em um único stack, facilitando a configuração de novos projetos e a padronização do ambiente entre equipes.

## Serviços incluídos

- [MySQL v8.4][l-mysql]
- [PostgreSQL (pgvector) 18][l-postgres]
- [Redis][l-redis]
- [Mailpit][l-mailpit] — servidor SMTP para captura de emails em desenvolvimento
- [Caddy][l-caddy] — proxy reverso com suporte a HTTPS automático
- [Durabull][l-durabull] — interface web para gerenciamento de filas Redis

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) e [Docker Compose](https://docs.docker.com/compose/install/)

## Instalação

### 1. Criar a rede externa do Docker

A rede `jp-networks` é declarada como `external` no `docker-compose.yml`, ou seja, ela **não é criada automaticamente**. Você precisa criá-la antes de iniciar os containers:

```bash
docker network create jp-networks
```

> **Nota:** esse comando só precisa ser executado uma vez. A rede persiste entre reinicializações do Docker.

### 2. Configurar variáveis de ambiente

```bash
cp .env.example .env
```

Edite o arquivo `.env` conforme necessário. Os valores padrão já funcionam para uso local.

### 3. Iniciar os containers

```bash
docker compose up -d
```

## Comandos úteis

```bash
# Ver todos os comandos disponíveis no Makefile
make help

# Iniciar containers
make docker-start

# Iniciar containers com build
make docker-build

# Desligar containers
make docker-stop

# Rebuild de todos os containers
make docker-rebuild-all

# Limpar cache do Redis
make flush-redis
```

## Portas padrão

| Serviço    | Porta | Descrição                  |
| ---------- | ----- | -------------------------- |
| PostgreSQL | 5432  | Banco de dados             |
| MySQL      | 3306  | Banco de dados             |
| Redis      | 6379  | Cache / filas              |
| Mailpit    | 1025  | SMTP (envio de emails)     |
| Mailpit    | 8025  | Dashboard web              |
| Caddy      | 80    | HTTP proxy                 |
| Caddy      | 443   | HTTPS proxy                |
| Durabull   | 3030  | Interface web              |

> As portas podem ser alteradas no arquivo `.env`.

## Interfaces web

- **Mailpit Dashboard:** <http://localhost:8025>
- **Durabull:** <http://localhost:3030>

## Editar arquivo de hosts

Para usar os domínios do Caddy (`mc.local`, `gifzy.test`, `api.gifzy.test`), adicione ao arquivo de hosts:

- Windows: `C:\Windows\System32\drivers\etc\hosts`
- Linux/macOS: `/etc/hosts`

```text
127.0.0.1 mc.local
127.0.0.1 gifzy.test
127.0.0.1 api.gifzy.test
```

## Caddy — proxy reverso

O Caddy é configurado via `docker/caddy/Caddyfile`. Ele usa `host.docker.internal` para rotear requisições do container para serviços rodando na máquina host.

> **⚠️ Aviso:** `host.docker.internal` é um recurso do Docker Desktop disponível apenas em ambientes de desenvolvimento (macOS e Windows). Ele **não funciona em produção** nem em hosts Linux sem configuração adicional. Para ambientes de produção, use nomes de serviço do Docker Compose ou endereços IP reais.

## Credenciais padrão

Todos os serviços usam `proxydev` como usuário e senha padrão. Veja `.env.example` para a lista completa de variáveis.

[l-postgres]: https://hub.docker.com/r/pgvector/pgvector
[l-mysql]: https://hub.docker.com/_/mysql
[l-redis]: https://hub.docker.com/_/redis
[l-mailpit]: https://github.com/axllent/mailpit
[l-caddy]: https://hub.docker.com/_/caddy
[l-durabull]: https://durabull.io/documentation/self-hosting/installation
