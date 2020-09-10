# Project Name

Description of the project here...

## Development

A `Dockerfile` builds the application and a `docker-compose.yml` configuration
is provided for application orchestration during development. Developers should
only interact with the project through the container(s). A number of commands
are included to aide with this workflow -- provided by `make` -- including the
php development server and code quality checks.

```console
dev:~$ make
```

After launching the development server you may start making http requests to
[`localhost:8094`](http://localhost:8094).

All tests and code quality checks are ran using the `quality` command.

```console
dev:~$ make quality
```

Additional commands are included for managing dependencies, including `shell`,
`logs` and `update`. See [`Makefile`](Makefile) for a full list of commands.

```console
dev:~$ make require PACKAGE=phpunit/phpunit
```

All code quality checks and tests must run and pass before a commit is made.

### Hooks

A set of Git Hooks are included for ensuring compliance with code requirements,
enable them by running the following command:

```console
dev:~$ git config core.hooksPath .github/hooks
```
