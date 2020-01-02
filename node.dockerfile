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

# wait
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

RUN groupadd saseul \
    && useradd -m -s /bin/bash saseul -g saseul -G www-data

USER saseul:saseul

WORKDIR /app/saseul

COPY ./src ./src

CMD /wait && php src/saseulsvc DaemonLoader
