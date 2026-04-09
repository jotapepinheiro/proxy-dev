PATH  := $(PATH):$(PWD)/bin:
SHELL := /bin/bash

ifneq (,$(wildcard ./.env))
include .env
export
endif

.PHONY: help
.DEFAULT_GOAL = help

CONTAINER ?= $(CONTAINER_NAME)
CONTAINER ?= proxydev

## —— Docker 🐳  ———————————————————————————————————————————————————————————————
docker-start: ## Iniciar Docker
	docker compose up -d

docker-build: ## Iniciar Docker com build
	docker compose up -d --build

docker-stop: ## Desligar Docker
	docker compose down

docker-rebuild-all: ## Rebuild em todos os containers
	make docker-stop docker-build

flush-redis: ## Limpar cache do Redis
	docker exec -it $(CONTAINER)-redis redis-cli -a "$${REDIS_PASSWORD:-proxydev}" flushall

## —— Monitoramento 📊 ————————————————————————————————————————————————————————
logs: ## Exibir logs de todos os containers (follow)
	docker compose logs -f

logs-%: ## Exibir logs de um serviço (ex: make logs-redis)
	docker compose logs -f $*

ps: ## Listar containers e seus status
	docker compose ps

## —— Shell 🐚 ————————————————————————————————————————————————————————————————
shell-postgres: ## Abrir shell no container PostgreSQL
	docker exec -it $(CONTAINER)-postgres bash

shell-mysql: ## Abrir shell no container MySQL
	docker exec -it $(CONTAINER)-mysql bash

shell-redis: ## Abrir redis-cli autenticado
	docker exec -it $(CONTAINER)-redis redis-cli -a "$${REDIS_PASSWORD:-proxydev}"

shell-caddy: ## Abrir shell no container Caddy
	docker exec -it $(CONTAINER)-caddy sh

shell-durabull: ## Abrir shell no container Durabull
	docker exec -it $(CONTAINER)-durabull sh

shell-mailpit: ## Abrir shell no container Mailpit
	docker exec -it $(CONTAINER)-mailpit sh

## —— Limpeza 🧹 ——————————————————————————————————————————————————————————————
destroy: ## Parar e remover containers, volumes e redes
	docker compose down -v --remove-orphans

## —— Outros 🛠️️ ———————————————————————————————————————————————————————————————
help: ## Lista de commandos
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' Makefile \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-24s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m## /[33m/' && printf "\n"
