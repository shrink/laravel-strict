# Project Name

Description of the project here...

## Development

A `Dockerfile` builds the application and a [`docker-compose.yml`][dc-config]
configuration is provided for application orchestration during development.
Developers should only interact with the project through the container(s). A
number of commands are included to aide with this workflow — provided by `make`.

```console
dev:~$ make
```

After launching the development environment you may start making http requests
to [`localhost:8094`](http://localhost:8094).

All tests and code quality checks are ran using the `check` command.

```console
dev:~$ make check
```

Additional commands are included for the development lifecycle, including
`shell`, `logs` and `update` — see [`Makefile`](Makefile) for a full list of
commands.

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

[dc-config]: docker-compose.yml
