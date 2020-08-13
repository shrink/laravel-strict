export COMPOSE_PROJECT_NAME = $(shell basename $(shell pwd))

APP ?= app
IMAGE = ${COMPOSE_PROJECT_NAME}_${APP}:latest

CONTAINER_COMMAND = docker-compose run --rm ${APP}
COMPOSER_COMMAND = ${CONTAINER_COMMAND} composer --verbose

DEFAULT = "\033[0m"
RED = "\033[0;31m"

# Set up any pre-requisites required for the application and then serve it
begin:
	cp -n .env.example .env || true
	make serve

# Serve the application using the PHP development server on the port specified
# in docker-compose.yml
serve:
	docker-compose up

# Build the application Docker image
build:
    docker build . && (docker images --format='{{.ID}}' | head -1)

# Tag a new release of the application
release:
	git fetch && \
	git tag -fsa v$(VERSION) -m 'v$(VERSION)' && \
	git push -f origin v$(VERSION)

# Run the application's quality check
quality:
	${COMPOSER_COMMAND} quality

# Run the application's tests
test:
	${COMPOSER_COMMAND} test

# Run the application's PHP Insights
insights:
	${COMPOSER_COMMAND} insights -- -v

# Require a new composer dependency
require:
	${COMPOSER_COMMAND} require --prefer-source $(PACKAGE)

# Update the application's composer dependencies
update:
	${COMPOSER_COMMAND} update

# Install all of the application's composer dependencies
install:
	${COMPOSER_COMMAND} install

# Refresh the application environment -- clean dependencies
refresh:
	make clean && make

# Log in to the container
shell:
	docker-compose run ${APP} sh

# Clean the docker-composer environment by removing all containers, images and
# volumes
clean:
	docker-compose down -v --rmi all --remove-orphans

# Get the name of the service that is being using by commands in this Makefile
service:
	echo "Service served by make is ${COMPOSE_PROJECT_NAME}_${APP}"
