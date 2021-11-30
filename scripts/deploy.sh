#!/bin/bash

all() {
	cd ../charts
	for chart in $(ls)
	do
		if [ $chart != 'core' ]
		then
			helm upgrade --install $chart;
		fi
	done
}

all
