### Install

```
cp ./src/.env.example ./src/.env
docker compose up -d
docker compose run --rm composer install
docker compose run --rm artisan migrate
docker compose run --rm artisan db:seed
docker compose run --rm artisan key:generate
docker compose run --rm artisan storage:link --force
```