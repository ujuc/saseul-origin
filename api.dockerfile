FROM php:7.3-fpm

RUN apt update \
    && apt install -y -qq --no-install-recommends libmemcached-dev zlib1g-dev \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-source extract \
    && pecl install xdebug memcached mongodb \
    && docker-php-ext-enable xdebug memcached mongodb \
    && docker-php-ext-install -j$(nproc) pcntl \
    && docker-php-source delete

RUN groupadd saseul \
    && useradd -m -s /bin/bash saseul -g saseul -G www-data

USER saseul:saseul

WORKDIR /app/saseul

COPY ./src ./src
