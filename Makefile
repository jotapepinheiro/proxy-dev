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
	docker exec -it $(CONTAINER)-redis redis-cli flushall

## —— Outros 🛠️️ ———————————————————————————————————————————————————————————————
help: ## Lista de commandos
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-24s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m## /[33m/' && printf "\n"
