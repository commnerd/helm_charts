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

.PHONY: deploy releases chart-updates

default: deploy

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
		CHART=$$(basename $$(dirname $$update));\
		ACTION="install";\
		if [ "$$(helm list | tail -n +2 | awk '{ print $1 }' | grep $$RELEASE)" ]; then\
			ACTION="upgrade";\
		fi;\
		echo "helm $$ACTION $$RELEASE ../../charts/$$CHART -f $$update";\
		helm $$ACTION $$RELEASE ../../charts/$$CHART -f $$update;\
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
		CHART=$$(basename $$(dirname $$update));\
		ACTION="install";\
		if [ "$$(helm list | tail -n +2 | awk '{ print $1 }' | grep $$RELEASE)" ]; then\
			ACTION="upgrade";\
		fi;\
		echo "helm $$ACTION $$RELEASE ../../charts/$$CHART -f $$update --dry-run --debug";\
		helm $$ACTION $$RELEASE ../../charts/$$CHART -f $$update --dry-run --debug;\
	done;