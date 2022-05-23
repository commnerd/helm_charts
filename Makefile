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

.PHONY: test
test:
	@echo '$(REMOVE_NAMESPACES)'
