# Use a imagem oficial do PHP com FPM e Alpine para leveza
FROM php:8.3-fpm-alpine

# Instalar dependências do sistema e extensões PHP necessárias para o Laravel
RUN apk add --no-cache \
    nginx \
    wget \
    icu-dev \
    libxml2-dev \
    git \
    unzip \
    libpng-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    sqlite-dev \
    bash

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    pdo_sqlite \
    intl \
    xml \
    gd \
    zip \
    bcmath

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar diretório de trabalho
WORKDIR /var/www/html

# Configurar o Nginx e Entrypoint primeiro (ajuda no cache e evita erros de contexto)
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/http.d/default.conf
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

# Copiar os arquivos do projeto
COPY . .

# Instalar dependências do Composer (apenas produção)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Ajustar permissões para o Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expor a porta que o Render vai usar
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
