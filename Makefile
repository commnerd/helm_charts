CHARTS := $(shell ls ./charts)

.PHONY: default test deploy lint repo_update $(CHARTS)

HELM := $(shell which helm)
GIT := $(shell which git)
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

default: test

test: repo_update lint
	$(MAKE) -C releases $@

lint: check_helm
	@for f in $(CHARTS); \
	do \
		$(HELM) lint ./charts/$${f};\
	done;

check_git:
	@if [ ! "$(GIT)" ]; then \
		echo "Git must be installed" 1>$$2;\
		exit 1;\
	fi

check_helm:
	@if [ ! "$(HELM)" ]; then \
		echo "Git must be installed" 1>$$2;\
		exit 1;\
	fi

repo_update: check_git
	@if [ "$$($(GIT) branch -a | grep remotes/origin/$(BRANCH))" ]; then\
		$(GIT) pull;\
	fi;

%:
	$(MAKE) -C releases $@
