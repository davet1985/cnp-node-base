.DEFAULT_GOAL:= build

.REGISTRY = hmctspublic.azurecr.io
.SANDBOX_REGISTRY = hmctssandbox.azurecr.io
.NAMESPACES	= base/node

.REFS =	alpine-lts-16►alpine \
		buster-slim-lts-16►buster-slim

define run-docker
	docker build \
		-t $(.REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ►, ,$(1))) \
		-f $(word 2,$(subst ►, ,$(1)))/Dockerfile \
		.

endef

define run-test
	@./test-build.sh $(.REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ►, ,$(1)))

endef

define push-sandbox
	docker tag \
		$(.REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ►, ,$(1))) \
		$(.SANDBOX_REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ►, ,$(1)))
	docker push $(.SANDBOX_REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ►, ,$(1)))

endef

help:
	@echo ""
	@echo " Available commands:"
	@echo " -------------------"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf " make \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

build: ## Build locally the base images.
	$(foreach ref,$(.REFS),$(call run-docker,$(ref)))

test: ## Test basic properties of the images, e.g. user, workdir, default command.
	$(foreach tag,$(.REFS),$(call run-test,$(tag)))

sandbox: ## Tag the images and pushes them to hmctssandbox.azurecr.io sandbox ACR (make sure you are logged in).
	$(foreach ref,$(.REFS),$(call push-sandbox,$(ref)))

.PHONY: build test sandbox help
