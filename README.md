# DOCKER

## O que este repositório contém

- [Mysql v8.0.32][l-mysql]
- [Postgres v13][l-postgres]
- [Redis][l-redis]
- [Mailtip][l-mailpit]

---

```bash
# Instale a Rede Externa do Docker
docker network create jp-networks
```

```bash
# Copiar arquivo .env.exemple para .env
cp .env.example .env 
```

```bash
# Comandos disponíveis no arquivo Makefile
make help
```

```bash
# Iniciar containers
docker compose up -d
```

```bash
# Desligar containers
docker compose down
```

```bash
# Rebuild Todos Container
docker compose down && docker compose up -d --build
```

```bash
# Limpar Redis
docker exec -it proxydev-redis redis-cli flushall
```

---

### Editar Arquivo de Hosts

```text
## No Windows:
C:\Windows\System32\drivers\etc\hosts

## No Linux/Mac:
/etc/hosts

########################

127.0.0.1       redis
127.0.0.1       mysql
127.0.0.1       postgres
127.0.0.1       mailpit
127.0.0.1       sonar
```

---

### Redis Web

> <http://redis:9987>

### Mailpit Web

> <http://mailpit:9987>

[l-postgres]: https://hub.docker.com/_/postgres
[l-mysql]: https://hub.docker.com/_/mysql
[l-redis]: https://hub.docker.com/_/redis
[l-mailpit]: https://github.com/axllent/mailpit
