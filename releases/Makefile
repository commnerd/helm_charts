SUBDIRS := $(wildcard */.)

default test: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: default test $(SUBDIRS)