FROM ghcr.io/shrink/docker-php-api:7.4 as php

USER root
RUN docker-php-ext-install pdo_mysql
USER nobody

FROM php as dependencies

ENV HOME=/run

COPY --from=composer:1 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer global require hirak/prestissimo --dev --prefer-dist && \
    composer install --no-ansi --no-autoloader --no-interaction

COPY --chown=nobody . ./
RUN composer dump-autoload

FROM dependencies as test
RUN composer check || echo "error" > error.exit

RUN mv junit.xml artifacts/psalm.xml
RUN [[ ! -f error.exit ]] && exit 0

FROM dependencies as production
RUN composer install --no-dev
RUN composer dump-autoload --optimize

FROM php
COPY --chown=nobody . ./
COPY --from=test /srv/artifacts /srv/artifacts
COPY --from=production /srv/vendor /srv/vendor
