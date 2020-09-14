MAKEFLAGS += --silent

include .env.example
-include .env

SERVICE_NAME = app
APP_NAME = $(SERVICE_PREFIX)_${SERVICE_NAME}

CONTAINER_COMMAND = make container && docker-compose exec -T ${SERVICE_NAME}
COMPOSER_COMMAND = ${CONTAINER_COMMAND} composer --verbose

# Set up any pre-requisites required for the application and then serve it in
# detached mode
.PHONY: begin
begin: .env container
	echo "\033[92m»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"
	echo "  Launched application at http://localhost:$(SERVER_PORT)"
	echo "««««««««««««««««««««««««««««««««««««««««««««««««««\033[0m"

# Make environment file and generate application key
.env:
	cp -n .env.example .env
	make generate-key

# Run application in detached mode
.PHONY: container
container:
	docker-compose up -d

# Listen to the logs for the application
.PHONY: logs
logs:
	docker logs -f ${APP_NAME}

# Attach to the application docker instance
.PHONY: attach
attach:
	docker attach ${APP_NAME}

# Build the application Docker image
.PHONY: build
build:
	docker build . -t ${APP_NAME} && (docker images --format='{{.ID}}' | head -1)

# Tag a new release of the application
.PHONY: release
release:
	git fetch && \
	git tag -fsa v$(VERSION) -m 'v$(VERSION)' && \
	git push -f origin v$(VERSION)

# Run the application's quality check
.PHONY: quality
quality:
	${COMPOSER_COMMAND} quality

# Run the application's tests
.PHONY: test
test:
	${COMPOSER_COMMAND} test

# Run the application's PHP Insights
.PHONY: insights
insights:
	${COMPOSER_COMMAND} insights -- -v

# Require a new composer dependency
.PHONY: require
require:
	${COMPOSER_COMMAND} require --prefer-source $(PACKAGE)

# Update the application's composer dependencies
.PHONY: update
update:
	${COMPOSER_COMMAND} update

# Install all of the application's composer dependencies
.PHONY: install
install:
	${COMPOSER_COMMAND} install

# Generate a new application key
.PHONY: generate-key
generate-key:
	${COMPOSER_COMMAND} generate-key

# Refresh the application environment -- clean dependencies
.PHONY: refresh
refresh: clean begin

# Log in to the container
.PHONY: shell
shell:
	${CONTAINER_COMMAND} sh

# Clean the docker-composer environment by removing all containers, images and
# volumes
.PHONY: clean
clean:
	docker-compose down -v --rmi all --remove-orphans
