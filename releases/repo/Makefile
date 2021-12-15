RELEASES := \
	$(shell \
		git diff $$(echo -n $$(git log | grep ^commit | head -n 2 | tac | awk '{ print $$2 }') | sed 's/ /../') | \
		grep ^diff | \
		awk '{ print $$3 }' | \
		grep ^a\/releases\/repo | \
		grep \.yaml$$ | \
		sed 's/^a\/releases\/repo/./'  \
	)

.PHONY: default test deploy

default: test

test:
	@UPDATES="";\
	for update in $(RELEASES); do\
		RELEASE=$$(basename $${update%.*});\
		CHART=$$(basename $$(dirname $$update));\
		REPO=$$(basename $$(dirname $$(dirname $$update)));\
		ACTION="install";\
		if [ "$$(helm list | tail -n +2 | awk '{ print $1 }' | grep $$RELEASE)" ]; then\
			ACTION="upgrade";\
		fi;\
		echo "helm $$ACTION $$RELEASE $$REPO/$$CHART -f $$update --dry-run --debug";\
		helm $$ACTION $$RELEASE $$REPO/$$CHART -f $$update --dry-run --debug;\
	done;

deploy:
	@UPDATES="";\
	for update in $(RELEASES); do\
		RELEASE=$$(basename $${update%.*});\
		CHART=$$(basename $$(dirname $$update));\
		REPO=$$(basename $$(dirname $$(dirname $$update)));\
		ACTION="install";\
		if [ "$$(helm list | tail -n +2 | awk '{ print $1 }' | grep $$RELEASE)" ]; then\
			ACTION="upgrade";\
		fi;\
		echo "helm $$ACTION $$RELEASE $$REPO/$$CHART -f $$update";\
		helm $$ACTION $$RELEASE $$REPO/$$CHART -f $$update;\
	done;