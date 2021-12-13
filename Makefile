CHARTS := $(shell ls ./charts)

.PHONY: default test deploy lint repo_update $(CHARTS)

HELM := $(shell which helm)
GIT := $(shell which git)

default: test

test: repo_update lint
	$(MAKE) -C releases $(MAKECMDGOALS)

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

repo_update: check_git check_helm
	$(GIT) pull
	$(HELM) repo update
