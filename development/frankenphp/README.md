## Requirements

-   Install Octane for the Laravel source: `composer require laravel/octane`

## Usage

```sh
cp .env.example .env
cp ./src/.env.example ./src/.env

# Get UID and GID CONTAINER_USER to update ./.env values
id -u
id -g
whoami

# Update ./src/.env values

# Starting services
docker compose up -d --build --remove-orphans

# Attach app terminal
docker exec -it ns-money-admin-app-1 sh
```
