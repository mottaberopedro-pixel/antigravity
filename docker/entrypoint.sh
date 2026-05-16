#!/bin/bash

# Garante que o diretório de banco de dados existe (importante para volumes persistentes)
mkdir -p /var/www/html/database

# Se o banco SQLite não existir no volume persistente, cria ele e roda as migrations/seeds
if [ ! -f /var/www/html/database/database.sqlite ]; then
    echo "Banco de dados não encontrado. Inicializando..."
    touch /var/www/html/database/database.sqlite
    php artisan migrate --force
    php artisan db:seed --class=HealthSystemSeeder --force
fi

# Limpar e gerar cache de configurações para produção
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Ajustar permissões novamente por segurança (caso o volume tenha mudado algo)
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Iniciar o PHP-FPM em background
php-fpm -D

# Iniciar o Nginx em foreground
echo "Servidor pronto!"
nginx -g "daemon off;"
