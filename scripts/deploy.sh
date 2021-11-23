#!/bin/bash

all() {
	cd ../charts
	for chart in $(ls)
	do
		if [ $chart != 'core' ]
		then
			helm dep build $chart;
			helm upgrade $chart;
		fi
	done
}

all
