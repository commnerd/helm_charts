#!/bin/bash

all() {
	cd ../charts
	for chart in $(ls)
	do
		helm upgrade --install $chart $chart;
	done
}

all
