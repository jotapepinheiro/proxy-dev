# Proxy Dev

Stack Docker Compose para desenvolvimento local com serviços de infraestrutura compartilhados.

## Serviços do stack

- [MySQL 8.0.32][l-mysql]
- [PostgreSQL (pgvector) 18][l-postgres]
- [Redis][l-redis]
- [Mailpit][l-mailpit]
- [Caddy][l-caddy]
- [Durabull][l-durabull]

## Setup rápido

```bash
# 1) Crie a rede externa (uma única vez)
docker network create jp-networks

# 2) Copie as variáveis de ambiente
cp .env.example .env

# 3) Veja os comandos disponíveis
make help

# 4) Suba os containers
make docker-start
```

Comandos úteis:

```bash
make docker-build        # sobe com rebuild
make docker-stop         # derruba o stack
make docker-rebuild-all  # down + build + up
make flush-redis         # limpa cache Redis
```

## Hosts locais (opcional)

Para usar os domínios do Caddy (`mc.local`, `gifzy.test`, `api.gifzy.test`), adicione:

```text
127.0.0.1 mc.local
127.0.0.1 gifzy.test
127.0.0.1 api.gifzy.test
```

Arquivo de hosts:

- Windows: `C:\Windows\System32\drivers\etc\hosts`
- Linux/macOS: `/etc/hosts`

## Acessos web

- Mailpit UI: <http://localhost:8025>
- Durabull UI: <http://localhost:3030>

[l-postgres]: https://hub.docker.com/r/pgvector/pgvector
[l-mysql]: https://hub.docker.com/_/mysql
[l-redis]: https://hub.docker.com/_/redis
[l-mailpit]: https://github.com/axllent/mailpit
[l-caddy]: https://hub.docker.com/_/caddy
[l-durabull]: https://durabull.io/documentation/self-hosting/installation
