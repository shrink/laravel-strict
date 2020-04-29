FROM php:7.4-fpm-alpine3.10 as php

RUN apk add gnu-libiconv oniguruma-dev \
    --update-cache \
    --allow-untrusted \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN docker-php-ext-install \
    opcache \
    pdo_mysql

RUN apk add --no-cache fcgi busybox

RUN wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

RUN set -xe && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf

FROM php as dependencies
WORKDIR /srv

RUN mkdir -p /srv/storage/app/public \
    && mkdir -p /srv/storage/framework/cache/data \
    && mkdir -p /srv/storage/framework/sessions \
    && mkdir -p /srv/storage/framework/testing \
    && mkdir -p /srv/storage/framework/views \
    && mkdir -p /srv/storage/logs

COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock /srv/
RUN composer global require hirak/prestissimo --dev && \
    composer install \
        --no-ansi \
        --no-autoloader \
        --no-interaction

COPY . /srv
RUN composer dump-autoload

FROM dependencies as test
RUN composer quality

FROM dependencies as clean
RUN composer install --no-dev
RUN composer dump-autoload --optimize

FROM php
COPY . /srv
COPY --from=clean /srv/vendor /srv/vendor
