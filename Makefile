CHARTS := $(shell ls ./charts)

.phony: default test deploy lint run_docker_k3s tear_down_docker_k3s check_docker repo_update ${CHARTS}

DOCKER := $(shell which docker)
K3S_VERSION := "v1.22.4-k3s1"
K3S_TEST_CONTAINER_NAME := "k3s_test_container"

default: test deploy

test: lint run_docker_k3s

deploy: repo_update
	$(MAKE) -C overrides	


lint:
	for f in ${CHARTS}; \
	do \
		helm lint ./charts/$${f};\
	done;

run_docker_k3s: check_docker
	docker run \
	--name ${K3S_TEST_CONTAINER_NAME} \
  -d --privileged rancher/k3s:${K3S_VERSION} server

tear_down_docker_k3s:
	${DOCKER} kill ${K3S_TEST_CONTAINER_NAME}
	${DOCKER} rm ${K3S_TEST_CONTAINER_NAME}
	${DOCKER} rmi rancher/k3s:${K3S_VERSION}

check_docker:
	@if [ ! "${DOCKER}" ]; then \
		exit 1; \
	fi

repo_update:
	helm repo update
