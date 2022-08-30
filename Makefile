BASE_DIR := $(shell pwd)
CHARTS := $(shell cd $(BASE_DIR)/charts && ls -d */ | sed "s/\///g")
HELM := $(shell which helm)
GIT := $(shell which git)
BRANCH := $(shell $(GIT) rev-parse --abbrev-ref HEAD)
HASH := $(shell $(GIT) log | grep ^commit | head -n 1 | awk '{ print $$2 }')
NAMESPACES := $(shell kubectl get namespaces | grep -v NAME | awk '{ print $$1 }')
DEPLOYMENTS := $(shell helm list | grep -v ^NAME | awk '{ print $$1 }')

DEFINED_NAMESPACES=$(shell find configs -iregex ".*\.yaml$\" | cut -d"/" -f 5)
DEFAULT_NAMESPACES=kube-node-lease kube-public kube-system default NAME
NAMESPACES_TO_KEEP=$(DEFAULT_NAMESPACES) $(DEFINED_NAMESPACES)
ADD_NAMESPACES=$(filter-out $(NAMESPACES) NAME, $(NAMESPACES_TO_KEEP))
REMOVE_NAMESPACES=$(filter-out $(NAMESPACES_TO_KEEP), $(NAMESPACES))

.PHONY: help
help:
	@echo "Usage:"
	@echo "  make [{subcommand}...]"
	@echo ""
	@echo "subcommands:"
	@echo "  deploy - Deploy updates"

.PHONY: deploy
deploy: repo-update lint tool-checks delete-namespaces add-namespaces

.PHONY: delete-namespaces
delete-namespaces:
	@echo 'The following name spaces will be deleted...  Implement this command when ALL are ok to remove.'
	@echo '$(REMOVE_NAMESPACES)'

.PHONY: add-namespaces
add-namespaces:
	@echo 'Adding namespaces:'
	@echo $(NAMESPACES_TO_KEEP)

.PHONY: tool-checks
tool-checks: helm-check git-check

.PHONY: git-check
git-check:
	@if [ ! "$(GIT)" ]; \
	then \
		echo "Git not found."; \
		exit 1; \
	fi;

.PHONY: helm-check
helm-check:
	@if [ ! "$(HELM)" ]; \
	then \
		echo "Helm not found."; \
		exit 1; \
	fi;

.PHONY: repo-update
repo_update: git-check
	@if [ "$$($(GIT) branch -a | grep remotes/origin/$(BRANCH))" ]; \
	then \
		$(GIT) pull;\
	fi;

.PHONY: lint
lint: helm-check
	@for f in $(CHARTS); \
	do \
		$(HELM) lint ./charts/$${f}; \
	done;
