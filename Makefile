# Hermes Docker Makefile

.PHONY: up down build logs shell pull clean setup-env

# Default: start with prebuilt image
up:
	docker compose up -d

# Build locally from Dockerfile
build:
	docker compose up -d --build

# Stop and remove containers
down:
	docker compose down

# View logs
logs:
	docker compose logs -f hermes

# Shell into container
shell:
	docker exec -it hermes-agent bash

# Pull latest image from GHCR
pull:
	docker pull ghcr.io/adit-firdaus/hermes-docker:latest

# Clean everything (containers, volumes, images)
clean:
	docker compose down -v --rmi all

# Setup environment file
setup-env:
	cp .env.example .env
	@echo "Edit .env with your API keys"

# Health check
health:
	docker exec hermes-agent hermes --version
