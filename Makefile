# Environment
PWD ?= `pwd`

# API
BIN_NAME ?= api
AUTHOR ?= marceloboeira
VERSION ?= 0.0.1
DEFAULT_HTTP_PORT ?= 8000

# Docker
DOCKER ?= `which docker`
DOCKER_PATH ?= $(PWD)/docker
DOCKER_FILE ?= $(DOCKER_PATH)/Dockerfile
DOCKER_TAG ?= $(AUTHOR)/$(BIN_NAME):$(VERSION)

# Docker Testing
DGOSS ?= `which dgoss`

# Docs
NPM ?= `which npm`
MARKSERV ?= `which markserv`
DOCS_PATH ?= /docs
DOCS_PORT ?= 9090

.PHONY: help
help: ## Lists the available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docs-install
docs-install: ## Installs documentation-related dependencies
	$(NPM) i -g markserv

.PHONY: docs
docs: ## Starts a local server to show docs
	$(MARKSERV) $(DOCS_PATH) --silent false --browser true --port $(DOCS_PORT)

.PHONY: docker-build
docker-build: ## Builds the core docker image compiling source for Rust and Elm
	$(DOCKER) build -t $(DOCKER_TAG) -f $(DOCKER_FILE) $(PWD)

.PHONY: docker-run
docker-run: ## Runs the latest docker generated image
	$(DOCKER) run -it -p $(DEFAULT_HTTP_PORT):$(DEFAULT_HTTP_PORT) $(DOCKER_TAG)

.PHONY: docker-test
docker-test: ## Tests the latest docker generated image
	cd $(DOCKER_PATH); $(DGOSS) run -p $(DEFAULT_HTTP_PORT) $(DOCKER_TAG)

.PHONY: test-all
test-all: docker-build docker-test ## Tests everything, EVERYTHING
