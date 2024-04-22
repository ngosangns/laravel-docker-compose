## Usage

```
# install
cp ./src/.env.example ./src/.env
docker compose up -d
docker compose run --rm composer install
docker compose run --rm artisan migrate
docker compose run --rm artisan db:seed
docker compose run --rm artisan key:generate
docker compose run --rm artisan storage:link --force

# cache
docker compose run --rm artisan icons:cache
docker compose run --rm artisan config:cache
docker compose run --rm artisan route:cache
docker compose run --rm artisan view:cache

# cache filament
docker compose run --rm artisan filament:cache-components

# clear cache
docker compose run --rm artisan optimize
```