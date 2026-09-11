#!/bin/sh
set -e

# Si vendor/ manque (volume monté vide), installer
if [ ! -d "vendor" ]; then
    composer install --no-interaction
fi

# Générer la clé UNIQUEMENT si elle n'existe pas déjà (évite de la régénérer à chaque restart)
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:CHANGE_ME" ]; then
    php artisan key:generate --force
fi

# Permissions (filet de sécurité, ex: volume Linux avec mauvais UID)
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Migrations : toujours safe à relancer
php artisan migrate --force

# Seed UNIQUEMENT en dev/local — jamais staging/prod
if [ "$APP_ENV" = "local" ]; then
    php artisan db:seed --force
fi

exec "$@"