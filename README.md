# Laravel Strict

**Laravel** [`8`][laravel-8] + **Docker**
[`shrink/docker-php-api`][shrink/docker-php-api]

Laravel Strict is a
[<img src="https://laravel.com/img/favicon/favicon-32x32.png" height="12"> Laravel][laravel]
install designed for building high quality containerised Laravel applications.

* **All HTTP requests served by Laravel** &mdash; ideal for an API
* Code quality enforced by [`nunomaduro/phpinsights`][php-insights] and
  [`vimeo/psalm`][psalm]
* Laravel configured with sane defaults and without unused boilerplate
* Continuous Delivery using [GitHub Actions][workflows/build] and the GitHub
  Container Registry
* [Development Environment](#development-environment) using Docker Compose
* [`Makefile`](Makefile) includes helpful development lifecycle commands

During development you can visit the [`laravel/laravel`][laravel/laravel]
repository to obtain any boilerplate required and explicitly introduce it into
the application, updating it to abide by the coding standards.

:thought_balloon: **Laravel Strict is intended for projects with strict code
quality requirements**, it was created for use in regulated environments where
confidence is more valuable than development speed — therefore it is very strict
and opinionated.

## Getting Started

After creating a new repository from this template, complete the following
steps:

- [ ] Write a description of the project in
      [`README-project.md`][readme-project]
- [ ] in [`.env.example`][.env.example] set a unique `APP_PORT` and `MYSQL_PORT`
      for the application
- [ ] Fill out [`composer.json`][composer.json] with project metadata
- [ ] Apply the project [Git Hooks][hooks] in your local environment
- [ ] Generate and add a [Personal Access Token][ghcr-pat] to the
      [repository secrets][secrets] using name `GHCR_PAT`
- [ ] Execute `$ mv README-project.md README.md`
- [ ] Commit!

## Changes

Many defaults have been removed, consolidated or changed to encourage best
practices.

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
[php-insights]: https://phpinsights.com
[psalm]: https://psalm.dev
[workflows/build]: .github/workflows/build.yml
[laravel/laravel]: https://github.com/laravel/laravel
[readme-project]: README-project.md
[.env.example]: .env.example
[composer.json]: composer.json
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
