# Laravel Scaffold

The Laravel Scaffold is a Laravel install with a number of helpful
development lifecycle features like coding standards added and much of the
Laravel boilerplate removed -- all remaining boilerplate has been updated to
pass validation.

During development you can visit the [`laravel/laravel`][laravel/laravel]
repository to obtain any boilerplate required and explicitly introduce it into
the application, updating it to abide by the coding standards during the
implementation.

## Getting Started

At the start of a new project you will need to clone this repository and then
complete the following steps:

- [ ] Fill out the description of the project in `README.md`
- [ ] Set default application environment variables in `.env.example`:
  - [ ] Unique HTTP `SERVER_PORT` for the application (e.g: `8094`)
  - [ ] Container's `SERVICE_PREFIX` (a valid [`container name`][docker/name])
- [ ] Fill out `composer.json` with package metadata
- [ ] Delete this file (`SCAFFOLD.md`)
- [ ] Commit!

## Notes

* Aliases have been removed from `config/app.php` as they encourage bad
  practices by bypassing dependency injection
* The `routes/` directory has been removed in favour of explicit route
  registration through a `ServiceProvider` as this encourages developers
  to think about HTTP as one interface into the application(s) of many rather
  than _the_ application

## Volume `vendor`

By default the `vendor` directory is a mounted volume to maximise performance,
however if you wish for developers to be able to access the contents of the
`vendor` directory you can modify `docker-compose.yml` like so:

```diff
volumes:
-  - vendor:/srv/vendor
+  - ./vendor:/srv/vendor
```

This will require an additional `composer install` as part of the begin step
in the `Makefile`, i.e:

```diff
begin:
	cp -n .env.example .env && make generate-key || true
	@make container
+	@make install
```

:warning: volume mounting dependencies in this way will reduce application
performance by ~10x

[laravel/laravel]: https://github.com/laravel/laravel
[docker/name]: https://github.com/moby/moby/blob/19.03/daemon/names/names.go#L6
