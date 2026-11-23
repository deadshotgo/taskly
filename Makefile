COMPOSE := docker compose -f deploy/docker-compose.yml
MODULES := ./services/taskly-api/... ./services/notifier/...

.PHONY: up down nuke logs ps build vet fmt check

up:
	$(COMPOSE) up --build -d --wait

down:
	$(COMPOSE) down

nuke:
	$(COMPOSE) down -v

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

build:
	go build $(MODULES)

vet:
	go vet $(MODULES)

fmt:
	@out=$$(gofmt -l services); if [ -n "$$out" ]; then echo "не відформатовано:"; echo "$$out"; exit 1; fi

check: fmt vet build
