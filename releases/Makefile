SUBDIRS := $(wildcard */.)

default test: $(SUBDIRS)
$(SUBDIRS): manage_repos
	$(MAKE) -C $@ $(MAKECMDGOALS)

manage_repos:
	@for repo in $$(helm repo list | tail -n +2 | awk '{print $1}'); do\
		helm repo delete $$repo;\
	done;\
	\
	@for repo in $$(cat manifest.yaml | sed 's/\(.*\): .*$/\1/g'); do\
		helm repo add $$repo $$(grep $$repo manifest.yaml | sed 's/.*: \(.*\)$$/\1/g');\
	done;

.PHONY: default test $(SUBDIRS)