# Use bash
SHELL       := bash
.SHELLFLAGS := -o pipefail -euc
.ONESHELL:

# Second expansion is used by the image targets to depend on their respective binaries. It is
# necessary because automatic variables are not set on first expansion.
# See https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html.
.SECONDEXPANSION:

# Define the list of actions that can be built.
ACTIONS := archive2disk cexec grub2disk image2disk kexec oci2disk qemuimg2disk rootio slurp syslinux writefile

# Define the commit for tagging images.
GIT_COMMIT := $(shell git rev-parse HEAD)

# Define container registry details.
CONTAINER_REPOSITORY := quay.io/tinkerbellrpardini/actions

# Platforms to build for
PLATFORMS := linux/amd64,linux/arm64

include Rules.mk

.PHONY: help
help: ## Print this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[%\/0-9A-Za-z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo
	@echo Individual actions can be built with their name. For example, \`make archive2disk\`.


.PHONY: $(ACTIONS)
$(ACTIONS): ## Build a specific action image.
	docker buildx build --progress=plain --platform $(PLATFORMS) --load -t  $@:latest -f ./$@/Dockerfile .

.PHONY: images
images: ## Build all action images.
images: $(ACTIONS)

.PHONY: push
push: ## Push all action images.
push: $(addprefix push-,$(ACTIONS))

.PHONY: push-%
push-%: ## Push a specific action image to the registry. This recipe assumes you are already authenticated with the registry.
	IMAGE_NAME=$(CONTAINER_REPOSITORY)/$*
	docker tag $*:latest $$IMAGE_NAME:$(GIT_COMMIT)
	docker tag $*:latest $$IMAGE_NAME:latest
	docker push $$IMAGE_NAME:$(GIT_COMMIT)
	docker push $$IMAGE_NAME:latest

formatters: ## Run all formatters.
formatters: $(toolBins)
	git ls-files '*.go' | xargs -I% sh -c 'sed -i "/^import (/,/^)/ { /^\s*$$/ d }" % && bin/gofumpt -w %'
	git ls-files '*.go' | xargs -I% bin/goimports -w %

include Lint.mk
