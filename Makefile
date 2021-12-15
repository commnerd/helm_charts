CHARTS := $(shell ls ./charts)
HELM := $(shell which helm)
GIT := $(shell which git)

.PHONY: default test deploy clean lint check_git check_helm repo_update clean $(CHARTS)

default: test

test deploy: repo_update lint clean
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
	$(GIT) submodule sync --recursive
	$(HELM) repo update

clean:
	@if [ -d openstack-helm-infra ]; then\
		rm -fR openstack-helm-infra;\
	fi
	$(MAKE) -C releases $(MAKECMDGOALS)
