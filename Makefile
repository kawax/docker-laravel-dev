DC = docker-compose
HOST = $(notdir $(CURDIR))
cmd = list

.PHONY: artisan

up:
	$(DC) up --build

upd:
	$(DC) up -d

down:
	$(DC) down

build:
	$(DC) build

ps:
	$(DC) ps

sh:
	$(DC) exec app /bin/bash

artisan:
	$(DC) run --rm app php artisan $(cmd)

migrate:
	$(DC) run --rm app php artisan migrate

ci:
	$(DC) run --rm app composer install

cu:
	$(DC) run --rm app composer update

open:
	open http://$(HOST).test:8000

hosts:
	sudo hostess add $(HOST).test 127.0.0.1

hosts_install:
	curl https://github.com/cbednarski/hostess/releases/download/v0.3.0/hostess_darwin_amd64 -L -o /usr/local/bin/hostness
	chmod +x /usr/local/bin/hostess
