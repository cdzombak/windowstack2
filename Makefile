SHELL:=/usr/bin/env bash

BIN_NAME:=windowstack2
BIN_VERSION:=$(shell ./.version.sh)

default: help
.PHONY: help  # via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: clean build ## Clean and build for macOS (all architectures)

.PHONY: clean
clean: ## Remove build products (./out)
	rm -rf ./out

.PHONY: build
build: ## Build for macOS (all architectures) to ./out
	mkdir -p out
	cp ./windowstack.sh ./out/${BIN_NAME}-${BIN_VERSION}-all
	chmod 0555 ./out/${BIN_NAME}-${BIN_VERSION}-all
	sed -i 's/__WINDOWSTACK_VERSION__="<dev>"/__WINDOWSTACK_VERSION__="${BIN_VERSION}"/g' ./out/${BIN_NAME}-${BIN_VERSION}-all

.PHONY: lint
lint: ## Lint all source files in this repository (requires nektos/act: https://nektosact.com)
	act --artifact-server-path /tmp/artifacts -j lint

.PHONY: update-lint
update-lint: ## Pull updated images supporting the lint target (may fetch >10 GB!)
	docker pull catthehacker/ubuntu:full-latest
