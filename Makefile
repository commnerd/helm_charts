BASE_DIR=$(shell pwd)
NAMESPACES=$(shell kubectl get namespaces | grep -v NAME | awk '{ print $$1 }')
DEFINED_NAMESPACES=$(shell cd releases && ls -d *)
DEFAULT_NAMESPACES=kube-node-lease kube-public kube-system default NAME
NAMESPACES_TO_KEEP=$(DEFAULT_NAMESPACES) $(DEFINED_NAMESPACES)
ADD_NAMESPACES=$(filter-out $(NAMESPACES) NAME, $(NAMESPACES_TO_KEEP))
REMOVE_NAMESPACES=$(filter-out $(NAMESPACES_TO_KEEP), $(NAMESPACES))

help:
	@echo "Usage:"
	@echo "  make [{subcommand}...]"
	@echo ""
	@echo "subcommands:"
	@echo "  test - Test update repos"

.PHONY: add-namespaces
add-namespaces:
	@for ns in $(ADD_NAMESPACES); \
	do \
		kubectl create namespace $$ns; \
	done

.PHONY: remove-namespaces
remove-namespaces:
	@for ns in $(REMOVE_NAMESPACES); \
	do \
		kubectl delete namespace $$ns; \
	done

.PHONY: sync-namespaces
sync-namespaces: add-namespaces

.PHONY: test clean
test: sync-namespaces test-install

.PHONY: test-install
test-install:
	@for ns in $(DEFINED_NAMESPACES); \
	do \
		pushd ./releases/$$ns; \
		if [ -d ./chart ]; \
		then \
			cd chart; \
			for chart in $$(ls -d *);
			do \
				pushd $$chart; \
					for values in $$(ls *.yaml); \
					do \
						release=$${values::-5}; \
						helm install $${release}   \
					done;
				popd; \
			done; \
		fi \
		if [ -d ./repo ]; \
		then \
			@(MAKE) -c ./repo test \
		fi \
	done

clean: remove-namespaces