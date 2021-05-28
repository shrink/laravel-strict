FROM ghcr.io/shrink/docker-php-api:sha-37b3cf1-8 as php

USER root
RUN docker-php-ext-install pdo_mysql
USER nobody

RUN mkdir -p /srv/storage/logs /srv/storage/views

FROM php as dependencies

ENV HOME=/run

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer install --no-ansi --no-autoloader --no-interaction

COPY --chown=nobody . ./
RUN composer dump-autoload

FROM dependencies as test
RUN composer check || echo "error" > error.exit

FROM test as validate
RUN [[ ! -f error.exit ]] || exit 1

FROM dependencies as production
RUN composer install --no-dev
RUN composer dump-autoload --optimize

FROM php
COPY --chown=nobody . ./
COPY --from=validate /srv/reports /srv/reports
COPY --from=production /srv/vendor /srv/vendor

HEALTHCHECK --interval=10s --timeout=1s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8080/.conductor/application || exit 1
