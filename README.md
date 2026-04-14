# Proxy Dev

Ambiente local de desenvolvimento com Docker Compose para subir rapidamente serviços de infraestrutura usados no dia a dia. Centraliza banco de dados, cache, envio de emails para testes e proxy web em um único stack, facilitando a configuração de novos projetos e a padronização do ambiente entre equipes.

## Serviços incluídos

- [MySQL v8.4][l-mysql]
- [PostgreSQL (pgvector) 18][l-postgres]
- [Redis][l-redis]
- [RabbitMQ][l-rabbitmq]
- [Mailpit][l-mailpit] — servidor SMTP para captura de emails em desenvolvimento
- [Caddy][l-caddy] — proxy reverso com suporte a HTTPS automático
- [Durabull][l-durabull] — interface web para gerenciamento de filas Redis
- [Firecrawl][l-firecrawl] — API de crawling/scraping self-hosted

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
| RabbitMQ   | 5672  | Broker AMQP                |
| RabbitMQ   | 15672 | Management UI              |
| Mailpit    | 1025  | SMTP (envio de emails)     |
| Mailpit    | 8025  | Dashboard web              |
| Caddy      | 80    | HTTP proxy                 |
| Caddy      | 443   | HTTPS proxy                |
| Durabull   | 3030  | Interface web              |
| Firecrawl  | 3002  | API web                    |

> As portas podem ser alteradas no arquivo `.env`.

## Interfaces web

- **Mailpit Dashboard:** <http://localhost:8025>
- **Durabull:** <http://localhost:3030>
- **RabbitMQ Management:** <http://localhost:15672>
- **Firecrawl API:** <http://localhost:3002>
- **Firecrawl Queue UI:** `http://localhost:3002/admin/${FIRECRAWL_BULL_AUTH_KEY}/queues`

## Firecrawl — configuração rápida

O Firecrawl foi adicionado com três serviços de apoio:

- `rabbitmq` (broker de filas)
- `nuq-postgres` (PostgreSQL interno do Firecrawl)
- `playwright-service` (renderização/navegação headless)

Variáveis principais no `.env`:

- `RABBITMQ_URL` (usada pelo Firecrawl em `NUQ_RABBITMQ_URL`)
- `FIRECRAWL_BULL_AUTH_KEY` (protege a Queue UI em `/admin/<key>/queues`)
- `FIRECRAWL_OPENAI_BASE_URL` + `FIRECRAWL_OPENAI_API_KEY` (modo OpenAI compatível, incluindo Ollama via `/v1`)
- `FIRECRAWL_MODEL_NAME` e `FIRECRAWL_MODEL_EMBEDDING_NAME`

Se você manteve os padrões do `.env.example`, a Queue UI fica em:

- `http://localhost:3002/admin/CHANGEME/queues`

## Firecrawl — testes rápidos

### 1. Testar scrape de uma única URL

```bash
curl -sS -X POST "http://localhost:3002/v1/scrape" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "formats": ["markdown"]
  }' | jq
```

Para exibir só o Markdown:

```bash
curl -sS -X POST "http://localhost:3002/v1/scrape" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com","formats":["markdown"]}' \
  | jq -r '.data.markdown'
```

### 2. Testar crawl (várias páginas) e recuperar por `id`

Iniciar crawl:

```bash
curl -sS -X POST "http://localhost:3002/v1/crawl" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://www.example.com",
    "limit": 5,
    "scrapeOptions": { "formats": ["markdown"] }
  }' | jq
```

Consultar resultado do crawl:

```bash
curl -sS "http://localhost:3002/v1/crawl/$ID" | jq
```

Exibir somente os conteúdos em Markdown:

```bash
curl -sS "http://localhost:3002/v1/crawl/$ID" | jq -r '.data[].markdown'
```

Se a resposta retornar o campo `next`, faça uma nova chamada para a URL de `next` para paginar os resultados.

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

A maior parte dos serviços usa `proxydev` como usuário/senha padrão. Exceção: no stack do Firecrawl, `FIRECRAWL_POSTGRES_*` usa `postgres/postgres/postgres` por padrão. Veja `.env.example` para a lista completa.

[l-postgres]: https://hub.docker.com/r/pgvector/pgvector
[l-mysql]: https://hub.docker.com/_/mysql
[l-redis]: https://hub.docker.com/_/redis
[l-mailpit]: https://github.com/axllent/mailpit
[l-caddy]: https://hub.docker.com/_/caddy
[l-durabull]: https://durabull.io/documentation/self-hosting/installation
[l-rabbitmq]: https://www.rabbitmq.com/docs
[l-firecrawl]: https://github.com/firecrawl/firecrawl
