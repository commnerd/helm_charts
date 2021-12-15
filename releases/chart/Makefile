HELM := $(shell which helm)

RELEASES := \
	$(shell \
		git diff $$(echo -n $$(git log | grep ^commit | head -n 2 | tac | awk '{ print $$2 }') | sed 's/ /../') | \
		grep ^diff | \
		grep \.yaml | \
		awk '{ print $$3 }' | \
		grep ^a\/releases\/chart | \
		sed 's/^a\/releases\/chart/\.\//' | \
		cut -d'/' -f2,3,4,5 \
	)

CHART_UPDATES := \
	$(shell \
		git diff $$(echo -n $$(git log | grep ^commit | head -n 2 | tac | awk '{ print $$2 }') | sed 's/ /../') | \
		grep ^diff | \
		awk '{ print $$3 }' | \
		grep ^a\/charts | \
		sed 's/^a\/charts/./' | \
		cut -d'/' -f2 | \
		sort | \
		uniq \
	)

.PHONY: default deploy releases chart-updates

default: test

deploy:
	@UPDATES="";\
	for chart_update in $(CHART_UPDATES); do\
		dir=$$(echo $$chart_update | cut -d'/' -f2);\
		echo $${PWD}/$$dir;\
		if [ -d "$$PWD/$$dir" ]; then\
			for file in $$(ls ./$$dir); do\
				UPDATES=$$(echo "$$UPDATES ./$$dir/$$file" | sed 's/^ *//g');\
			done;\
		fi;\
	done;\
	\
	for release in $(RELEASES); do\
		dir=$$(echo $$release | cut -d'/' -f2);\
		for file in $$(ls ./$$dir); do\
			UPDATES=$$(echo "$$UPDATES ./$$dir/$$file" | sed 's/^ *//g');\
		done;\
	done;\
	UPDATES=$$(echo $$UPDATES | sed 's/ /\n/g' | sort | uniq);\
	for update in $$UPDATES; do\
		RELEASE=$$(basename $${update%.*});\
		LATEST_RELEASE_HASH="$(shell git log $$update | head -n 1 | awk '{print $2}')";\
		CHART=$$(basename $$(dirname $$update));\
		LATEST_CHART_HASH=$(shell git log ../../charts/$$CHART | head -n 1 | awk '{print $2}');\
		LATEST_GIT_HASH=$$(git log | grep '$${LATEST_RELEASE_HASH}\|$${LATEST_CHART_HASH}' | head -n 1 | awk '{print $2}');\
		CURRENT_RELEASE_HASH=$$(sudo kubectl get deploy $${RELEASE}) -o jsonpath='{.metadata.annotations.git-hash}');\
		if [ "$${CURRENT_RELEASE_HASH}" != "$${LATEST_GIT_HASH}" ]; then\
			ACTION="install";\
			if [ ! "$${CURRENT_RELEASE_HASH}" != "" ]; then\
				ACTION="upgrade";\
			fi;\
			echo "$(HELM) $$ACTION $$RELEASE ../../charts/$$CHART -f $$update";\
			$(HELM) $$ACTION $$RELEASE ../../charts/$$CHART -f $$update;\
		fi;\
	done;

test:
	@UPDATES="";\
	for chart_update in $(CHART_UPDATES); do\
		dir=$$(echo $$chart_update | cut -d'/' -f2);\
		echo $${PWD}/$$dir;\
		if [ -d "$$PWD/$$dir" ]; then\
			for file in $$(ls ./$$dir); do\
				UPDATES=$$(echo "$$UPDATES ./$$dir/$$file" | sed 's/^ *//g');\
			done;\
		fi;\
	done;\
	\
	for release in $(RELEASES); do\
		dir=$$(echo $$release | cut -d'/' -f2);\
		for file in $$(ls ./$$dir); do\
			UPDATES=$$(echo "$$UPDATES ./$$dir/$$file" | sed 's/^ *//g');\
		done;\
	done;\
	UPDATES=$$(echo $$UPDATES | sed 's/ /\n/g' | sort | uniq);\
	for update in $$UPDATES; do\
		RELEASE=$$(basename $${update%.*});\
		LATEST_RELEASE_HASH="$(shell git log $$update | head -n 1 | awk '{print $2}')";\
		CHART=$$(basename $$(dirname $$update));\
		LATEST_CHART_HASH=$(shell git log ../../charts/$$CHART | head -n 1 | awk '{print $2}');\
		LATEST_GIT_HASH=$$(git log | grep '$${LATEST_RELEASE_HASH}\|$${LATEST_CHART_HASH}' | head -n 1 | awk '{print $2}');\
		CURRENT_RELEASE_HASH=$$(sudo kubectl get deploy $${RELEASE}) -o jsonpath='{.metadata.annotations.git-hash}');\
		if [ "$${CURRENT_RELEASE_HASH}" != "$${LATEST_GIT_HASH}" ]; then\
			ACTION="install";\
			if [ ! "$${CURRENT_RELEASE_HASH}" != "" ]; then\
				ACTION="upgrade";\
			fi;\
			echo "$(HELM) $$ACTION $$RELEASE ../../charts/$$CHART -f $$update --dry-run --debug";\
			$(HELM) $$ACTION $$RELEASE ../../charts/$$CHART -f $$update --dry-run --debug;\
		fi;\
	done;

%:
	@echo "$@ is not defined." 1>&2 \
	exit 1;