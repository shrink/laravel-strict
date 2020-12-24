# Laravel Strict

**Laravel** [`8`][laravel-8] + **Docker**
[`shrink/docker-php-api:8`][shrink/docker-php-api]

Laravel Strict is a
[<img src="https://laravel.com/img/favicon/favicon-32x32.png" height="12"> Laravel <sup>&neArr;</sup>][laravel]
install designed for building high quality containerised Laravel applications.

* **All HTTP requests served by Laravel** &mdash; ideal for an API
* Code quality enforced by [`vimeo/psalm`<sup>&neArr;</sup>][psalm] and
  [`squizlabs/php_codesniffer`<sup>&neArr;</sup>][phpcs]
* Laravel configured with sane defaults and without boilerplate
* Continuous Delivery using [GitHub Actions][workflows] and the GitHub Container
  Registry
* [Development Environment](#development-environment) using Docker Compose
* [`Makefile`](Makefile) with helpful development lifecycle commands

:thought_balloon: **Laravel Strict is intended for projects with strict code
quality requirements**, it was created for use in regulated environments where
confidence is more valuable than development speed.

1. [**Getting Started** with Laravel Strict](#getting-started)
2. [**Features** included in Laravel Strict](#features)
3. [**Differences** between Laravel Strict and Laravel](#differences)
4. [**Development Environment**](#development-environment)

## Getting Started

Laravel Strict is designed to be up and running immediately, producing a
_deployable_ application image from the first commit.
**[Generate<sup>&neArr;</sup>][generate-new] a new repository** from this
template and complete these steps from your new repository.

- [ ] Generate and add a [Personal Access Token<sup>&neArr;</sup>][ghcr-pat] to
      the [repository secrets][secrets] with name `GHCR_PAT`
- [ ] Fill out [`composer.json`][edit/composer.json] with project `name` and
      `description`
- [ ] [Create your `README.md`][create-readme] with a project name and
      description

Your application is now ready to go: a production-ready Docker image has been
built and pushed to the GitHub Container Registry by the
[`build`][workflows/build] workflow. Start developing!

```console
dev:~$ git clone https://github.com/example/my-strict-application.git
dev:~$ make
»» Launched application at http://localhost:8094
```

## Features

### Healthcheck

Docker's [`HEALTHCHECK`][docker-healthcheck] functionality declares a command
that Docker can use at runtime to check the health of a container. Laravel
Strict ships with a healthcheck endpoint (using [Conductor][conductor-laravel])
that is checked at a 10s interval.

## Differences

There are differences between this install of Laravel and the standard that a
developer will need to keep in mind. Many defaults have been removed,
consolidated or changed to encourage best practices.

During development any required boilerplate can be obtained from the
[`laravel/laravel`][laravel/laravel] repository. When introducing boilerplate
into the project the code must be updated to meet the quality standards of the
application.

### Configuration

Configuration has been moved from `config/*.php` into the application bootstrap
in [`bootstrap/app.php`][bootstrap] where all additional configuration of the
application should take place. All of Laravel's optional configuration options
have been removed, only required configuration is included by default.

Aliases have been removed as they encourage bypassing dependency injection.

### Routing

The `routes` directory has been removed in favour of explicit route registration
through a `ServiceProvider` for each component, as this encourages developers to
think about HTTP as one interface into the application — rather than _the_
application.

### Environment

Laravel ships with [`vlucas/phpdotenv`][phpdotenv] for easy environment
variable management, however for a containerised application this library is
unnecessary and may even compromise portability. All environment variables
should be provided via the container orchestration engine, e.g: Docker Compose.

### Application Build

[`.dockerignore`][docker-ignore] excludes all files by default before explicitly
including paths required by the application. Learn more about this approach in
[Getting Control Of Your `.dockerignore` Files][ignore-by-default] by
[@markbirbeck][markbirkbeck].

## Development Environment

### `make`

[`Makefile`](Makefile) includes a full suite of commands for use during the
development lifecycle. [Modern Make][modern-make] is recommended to provide a
dynamic command list.

```console
dev:~$ make help
  build                  Build the application's Docker image | TAG!
  check                  Run the application's code checks
  launch                 Launch development environment (default)
  logs                   Listen to the service logs
  shell                  Log in to the application container
  test                   Run the application's tests
  ...                    +14 more
```

### Environment Variables

Environment Variables should be explicitly set for each service in
[`docker-compose.yml`][dc-config] to emulate how environment variables will be
provided in production environments. A developer can use
[`docker-compose.override.yml`][dc-override] to provide values unique to their
local environment.

### Volume `vendor`

By default the `vendor` directory is a mounted volume to maximise performance,
however if you wish for developers to be able to access the contents of the
`vendor` directory you can modify [`docker-compose.yml`][dc-config] like so:

```diff
volumes:
-  - vendor:/srv/vendor
+  - ./vendor:/srv/vendor
```

This will require an additional dependency install as part of the `launch` step
in the `Makefile`, i.e:

```diff
launch: run
+	make install
```

:warning: volume mounting dependencies in this way will reduce application
performance in development by ~10x

[laravel]: https://laravel.com
[laravel-8]: https://laravel.com/docs/8.x
[shrink/docker-php-api]: https://github.com/shrink/docker-php-api
[psalm]: https://psalm.dev
[phpcs]: https://github.com/squizlabs/PHP_CodeSniffer
[workflows]: .github/workflows
[workflows/build]: .github/workflows/build.yml
[laravel/laravel]: https://github.com/laravel/laravel
[readme-project]: README-project.md
[edit/composer.json]: edit/main/composer.json
[docker/name]: https://github.com/moby/moby/blob/19.03/daemon/names/names.go#L6
[hooks]: README-project.md#hooks
[ghcr-pat]: https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images#authenticating-with-the-container-registry
[secrets]: settings/secrets
[dc-config]: docker-compose.yml
[dc-override]: https://docs.docker.com/compose/extends/#understanding-multiple-compose-files
[docker-ignore]: .dockerignore
[ignore-by-default]: https://youknowfordevs.com/2018/12/07/getting-control-of-your-dockerignore-files.html
[markbirkbeck]: https://github.com/markbirbeck
[bootstrap]: bootstrap/app.php
[phpdotenv]: https://github.com/vlucas/phpdotenv
[generate-new]: generate
[create-readme]: edit/main/README-project.md?filename=README.md
[modern-make]: https://github.com/tj/mmake
[docker-healthcheck]: https://docs.docker.com/engine/reference/builder/#healthcheck
[conductor-laravel]: https://github.com/shrink/conductor-laravel
