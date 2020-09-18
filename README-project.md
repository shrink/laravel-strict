# Project Name

Description of the project here...

## Development

The application is built as a Docker image defined in
[`Dockerfile`][dockerfile]. Docker Compose provides application orchestration
during development, as defined in [`docker-compose.yml`][dc-config]. Developers
should only interact with the project through the container(s). A number of
commands are included to aide with this workflow — provided by `make`.

```console
dev:~$ make
»» Launched application at http://localhost:8094
```

A full list of supported commands is available in [`Makefile`](Makefile) —
including `check`, `shell`, `logs`, `upgrade`, `build` and more.
[Modern Make][mmake] is recommended to gain a dynamic command list using
`make help`.

### Quality

Code quality is verified using the `check` command which executes all test
suites, performs static analysis and generates code insights.

```console
dev:~$ make check
```

### Hooks

A pre-commit Git Hook is included for ensuring compliance with code
requirements on commit, enable the Git Hook by running the following command:

```console
dev:~$ git config core.hooksPath .github/hooks
```

[dockerfile]: Dockerfile
[dc-config]: docker-compose.yml
[mmake]: https://github.com/tj/mmake
