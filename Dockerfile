FROM php:8.3-fpm-alpine

# Dependências do sistema (apenas o necessário)
RUN apk add --no-cache \
    nginx \
    icu-dev \
    libpng-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    bash

# Instalar APENAS extensões que NÃO vêm no PHP 8.3 Alpine
# (mbstring, curl, xml, pdo_sqlite, dom já estão incluídos)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    intl \
    gd \
    zip \
    bcmath

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiar dependências primeiro (melhor cache Docker)
COPY composer.json composer.lock ./

# Criar .env mínimo para o build
RUN echo "APP_KEY=base64:dGVtcG9yYXJ5a2V5Zm9yYnVpbGQ=" > .env

# Instalar dependências sem scripts do Laravel
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Copiar o resto do projeto
COPY . .

# Garantir .env e rodar discovery
RUN cp -n .env.example .env 2>/dev/null || true \
    && php artisan package:discover --ansi 2>/dev/null || true

# Nginx e Entrypoint
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/http.d/default.conf
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

# Permissões
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
