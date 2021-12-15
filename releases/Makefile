SUBDIRS := $(wildcard */.)
DOCKER := $(shell which docker)
DOCKER_TEST_INSTANCE := "k3s_test_instance"
K3S_VERSION := "v1.21.7-k3s1"
HELM := $(shell which helm)
PWD := $(shell pwd)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

test: manage_repos
	@if [ "$(DOCKER)" ]; then\
		$(MAKE) -f $(PWD)/Makefile docker_test;\
	elif [ "$(HELM)" ]; then\
		$(MAKE) -f $(PWD)/Makefile helm_test;\
	else\
		echo "No testing platform available" 1>&2;\
		exit 1;\
	fi;

docker_run:
	@if [ ! "$$($(DOCKER) ps | grep $(DOCKER_TEST_INSTANCE))" ]; then\
		$(DOCKER) run -d\
			--rm\
			--name $(DOCKER_TEST_INSTANCE)\
			--publish 8080:8080\
			--publish 6443:6443\
			--privileged\
			rancher/k3s:$(K3S_VERSION) server;\
		while [ ! "$$(sudo lsof -i:6443)" ]; do\
			echo "Sleeping... 1";\
			sleep 1;\
		done;\
	fi;
	@while [ ! "$$(sudo lsof -i:8080)" ]; do\
		echo "Sleeping... 2";\
		sleep 1;\
	done;

docker_test: docker_run
	@echo "RUNNING DOCKER TESTS!!!";

docker_clean:
	$(DOCKER) kill $(DOCKER_TEST_INSTANCE)

manage_repos:
	@for repo in $$(helm repo list | grep -v t3n | grep -v nexus | tail -n +2 | awk '{print $$1}'); do\
		helm repo remove $$repo;\
	done;\
	\
	for repo in $$(cat manifest.yaml | sed 's/\(.*\): .*$$/\1/g'); do\
		helm repo add $$repo $$(grep $$repo manifest.yaml | sed 's/.*: \(.*\)$$/\1/g');\
	done;

%:
	@echo "$@ is not defined." 1>&2 \
	exit 1;

clean: docker_clean

.PHONY: default test docker_test docker_run docker_clean clean $(SUBDIRS)