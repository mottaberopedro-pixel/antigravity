FROM php:8.3-fpm-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    nginx \
    icu-dev \
    libxml2-dev \
    git \
    unzip \
    libpng-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    sqlite-dev \
    oniguruma-dev \
    curl-dev \
    bash

# Instalar extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    pdo_sqlite \
    intl \
    xml \
    gd \
    zip \
    bcmath \
    mbstring \
    curl

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiar apenas composer.json e composer.lock primeiro (melhor cache de camadas)
COPY composer.json composer.lock ./

# Criar .env temporário para que os scripts do Laravel não quebrem
RUN cp -n .env.example .env 2>/dev/null || echo "APP_KEY=base64:temporary_key_for_build_only=" > .env

# Instalar dependências SEM rodar scripts do Laravel (evita erros com artisan)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Agora copiar o resto do projeto
COPY . .

# Garantir que .env existe e rodar os scripts do Laravel
RUN cp -n .env.example .env 2>/dev/null || true \
    && composer dump-autoload --optimize \
    && php artisan package:discover --ansi || true

# Configurar Nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/http.d/default.conf

# Configurar Entrypoint
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

# Permissões do Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
