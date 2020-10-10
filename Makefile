MAKEFLAGS += --silent

include .env.example
-include .env

SERVICE_PREFIX = $(basename $(pwd))
SERVICE_NAME = app

COMPOSER_COMMAND = make services && \
				   docker-compose exec ${SERVICE_NAME} composer

# Launch development environment
.PHONY: launch
launch: services
	echo "\033[92m»» Launched application at http://localhost:$(APP_PORT)\033[0m"

# Create a local environment configuration
.env:
	cp -n .env.example .env

# Run all services in detached mode
.PHONY: services
services: .env
	docker-compose up -d

# Listen to the service logs
.PHONY: logs
logs:
	docker-compose logs -f || exit 0

# Build the application's Docker image | TAG!
.PHONY: build
build:
	test -n "$(TAG)"
	docker build . -t ${SERVICE_PREFIX}_${SERVICE_NAME}:$(TAG)
	docker images --format='{{.ID}}: {{.Repository}}:{{.Tag}} {{.Size}}' | head -1

# Tag a new version of the application | VERSION!
.PHONY: version
version:
	test -n "$(VERSION)"
	git show --oneline -s
	read -p "Are you sure you want to force tag v$(VERSION)? Y [enter] / N [ctrl]+[c]"
	git tag -fsam ':tada: Version $(VERSION)' v$(VERSION) && \
	git push -f origin v$(VERSION)

# Run code checks non-interactively for pre-commit checks
.PHONY: pre-commit
pre-commit: services
	docker-compose exec -T ${SERVICE_NAME} composer check

# Run the application's code checks
.PHONY: check
check:
	${COMPOSER_COMMAND} check

# Run the application's tests
.PHONY: test
test:
	${COMPOSER_COMMAND} test

# Run the application's PHP Insights
.PHONY: insights
insights:
	${COMPOSER_COMMAND} insights -- -v

# Install all of the application's composer dependencies
.PHONY: install
install:
	${COMPOSER_COMMAND} install

# Upgrade the application's composer dependencies
.PHONY: upgrade
upgrade:
	${COMPOSER_COMMAND} upgrade

# Require a new composer dependency | PACKAGE?
.PHONY: require
require:
	${COMPOSER_COMMAND} require --prefer-source $(PACKAGE)

# Launch a clean local environment: reset then launch
.PHONY: clean
clean: down launch

# Log in to the application container
.PHONY: shell
shell: services
	docker-compose exec ${SERVICE_NAME} sh

# Stop local environment and remove Docker artifacts (volumes, containers...)
.PHONY: down
down:
	docker-compose down -v --rmi all --remove-orphans

# List supported commands
.PHONY: help
help:
	@echo "\`make help\` is not supported by native Make"
	@echo "Download Modern Make to gain access to a dynamic command list"
	@echo "\033[92m»»\033[0m https://github.com/tj/mmake"
