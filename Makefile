SERVER_PORT = $(shell export $(shell cat .env | xargs) && echo $$SERVER_PORT)
SERVICE_PREFIX = $(shell export $(shell cat .env | xargs) && echo $$SERVICE_PREFIX)

SERVICE_NAME = app
APP_NAME = $(SERVICE_PREFIX)_${SERVICE_NAME}

CONTAINER_COMMAND = make container && docker-compose exec ${SERVICE_NAME}
COMPOSER_COMMAND = ${CONTAINER_COMMAND} composer --verbose

# Set up any pre-requisites required for the application and then serve it in
# detached mode
begin:
	cp -n .env.example .env && make generate-key || true
	@make container
	@echo "\033[92m»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"
	@echo "  Launched application at http://localhost:$(SERVER_PORT)"
	@echo "««««««««««««««««««««««««««««««««««««««««««««««««««\033[0m"

# Run application in detached mode
container:
	@docker-compose up -d

# Listen to the logs for the application
logs:
	docker logs -f ${APP_NAME}

# Attach to the application docker instance
attach:
	docker attach ${APP_NAME}

# Build the application Docker image
build:
	docker build . -t ${APP_NAME} && (docker images --format='{{.ID}}' | head -1)

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

# Generate a new application key
generate-key:
	${COMPOSER_COMMAND} generate-key

# Refresh the application environment -- clean dependencies
refresh:
	make clean && make

# Log in to the container
shell:
	${CONTAINER_COMMAND} sh

# Clean the docker-composer environment by removing all containers, images and
# volumes
clean:
	docker-compose down -v --rmi all --remove-orphans
