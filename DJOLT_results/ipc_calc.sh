#!/bin/bash

for file in */*

for d in */ ; do
    	for file in "$d"/* do
		grep -rnw ./"$d"/"file" -e 'L1I LOAD' | awk '{print $1",", $4",", $8}' > ./"$d"/"file"/ipc.csv
	done
done
