# Laravel Scaffold

The Laravel Scaffold is a Laravel `v6` install with a number of helpful
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
- [ ] Decide on a unique HTTP port for the application (e.g: `8094`) and set the
      port in `.env` for the `SERVER_PORT` value and in the `README.md`
- [ ] Fill out `composer.json` with package metadata
- [ ] Delete this file (`SCAFFOLD.md`)
- [ ] Commit!

## Notes

* Aliases have been removed from `config/app.php` as they encourage bad
  practices by bypassing dependency injection
* The `routes/` directory has been removed in favour of explicit route
  registration through the `HttpServiceProvider` as this encourages developers
  to think about HTTP as one interface into the application(s) of many rather
  than _the_ application

## Volume `vendor`

By default the `vendor` directory is a mounted volume to maximise performance,
however if you wish for developers to be able to access the contents of the
`vendor` directory you can modify `docker-compose.yml` like so:

```yaml
volumes:
  - ./vendor:/srv/vendor:delegated
```

This will require an additional `composer install` as part of the build step
to make the dependencies available in the volume, i.e:

```makefile
begin:
	cp -n .env.example .env || true
    ${COMPOSER_COMMAND} install
	make serve
```

This will be slow due to the volume mounting, and may add 2+ minutes to the
first build. A faster (more complex) solution is to copy the contents of the
`vendor` directory from the image onto the host at first run, i.e:

```makefile
begin:
	cp -n .env.example .env || true
	docker-compose build
	if [ ! -d "vendor" ]; then \
		make build-files; \
	fi
	make serve

build-files:
	docker cp $$(docker create ${IMAGE}):srv/vendor/. vendor
```

[laravel/laravel]: https://github.com/laravel/laravel
