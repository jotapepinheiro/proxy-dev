# DOCKER

## O que este repositório contém

- [Mysql v8.0.32][l-mysql]
- [Postgres v13][l-postgres]
- [Redis][l-redis]
- [Redis Web-UI][l-redis-web-ui]
- [Sonar Qube][l-sonarqube]
- [Mailtip][l-mailpit]

---

```shell script
# Copiar arquivo .env.exemple para .env
cp .env.example .env 
```

```shell script
# Comandos disponíveis no arquivo Makefile
make help
```

```shell script
# Iniciar containers
docker compose up -d
```

```shell script
# Desligar containers
docker compose down
```

```shell script
# Rebuild Todos Container
docker compose down && docker compose up -d --build
```

```shell script
# Limpar Redis
docker exec -it proxydev-redis redis-cli flushall
```

## Instalar Sonar Scanner

```shell script
## Instalar pacote brew
brew install sonar-scanner

## Executar comando na raiz de cada projeto
sonar-scanner \
  -Dsonar.projectKey=microservices_customer_card_AYFjiSo1TwWNWyaxqqCA \
  -Dsonar.sources=app \
  -Dsonar.host.url=http://sonar:9000 \
  -Dsonar.token=sqp_c2f893a5436c8cf01144bf31f81850803942b8e4

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

### SonarQube Web

> <http://sonar:9000>

[l-postgres]: https://hub.docker.com/_/postgres
[l-mysql]: https://hub.docker.com/_/mysql
[l-redis]: https://hub.docker.com/_/redis
[l-redis-web-ui]: https://github.com/erikdubbelboer/phpRedisAdmin
[l-mailpit]: https://github.com/axllent/mailpit
[l-sonarqube]: https://docs.sonarsource.com/sonarqube/latest/
