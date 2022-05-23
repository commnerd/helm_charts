NAMESPACES=$(shell kubectl get namespaces)
DEFINED_NAMESPACES=$(shell cd releases && ls -d *)
DEFAULT_NAMESPACES="kube-node-lease kube-public kube-system default NAME"
REMOVED_NAMESPACES=$(filter-out $(DEFAULT_NAMESPACES) $(DEFINED_NAMESPACES), $(NAMESPACES))

help:
	@echo "Usage:"
	@echo "  make [{subcommand}...]"
	@echo ""
	@echo "subcommands:"
	@echo "  test - Test update repos"
