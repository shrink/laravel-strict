# Project Name

Description of the project here...

## Development

The application is built as a Docker image defined in
[`Dockerfile`][dockerfile]. Docker Compose provides application orchestration
during development, as defined in [`docker-compose.yml`][dc-config]. Developers
should only interact with the project through the container(s): a number of
helpful tasks are included to aide with this workflow using [Task][taskfile].

```console
dev:~$ task start
»» Launched application at http://localhost:8094
```

A full list of supported commands is available using `task` —
including `check`, `shell`, `logs`, `release` and more.

```console
dev:~$ task
task: Available tasks for this project: [...]
```

### Quality

Code quality is verified using the `check` command which executes all test
suites, performs static analysis and validates compliance with
[PSR-12: Extended Coding Style][psr-12].

```console
dev:~$ task check
```

[dockerfile]: Dockerfile
[dc-config]: docker-compose.yml
[psr-12]: https://www.php-fig.org/psr/psr-12/
[taskfile]: https://taskfile.dev/
