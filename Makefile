MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

apollo-fetch-schema:
	./apollo-ios-cli fetch-schema

apollo-generate:
	./apollo-ios-cli generate

config-generate:
	@ENV_PATH=$(ROOT)/.env; \
	. $$ENV_PATH; \
	export $$(cut -d= -f1 $$ENV_PATH); \
	envsubst < template.xcconfig > App/Config.xcconfig