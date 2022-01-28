#!/bin/bash

./build_champsim.sh hashed_perceptron FNL-MMA280520 next_line spp_dev no lru 1 

trace_dir=./ipc1_public

djolt=hashed_perceptron-D_JOLT-next_line-spp_dev-no-lru-1core
jip=hashed_perceptron-ipc-2020-paper91-code-next_line-spp_dev-no-lru-1core
no=hashed_perceptron-no-next_line-spp_dev-no-lru-1core
FNLMMA=hashed_perceptron-FNL-MMA280520-next_line-spp_dev-no-lru-1core

num_parallel_traces=25
count=0

warmup=50
exec=50

for file in "$trace_dir"/*
do
    echo "Processing trace: ${file##*/}"
    ./run_champsim.sh $FNLMMA $warmup $exec ${file##*/} &
    ((count=count+1))
    if [[ $count -gt $num_parallel_traces ]]
    then
        echo "Count greater than num_parallel_procs, waiting..."
        wait
        count=0
        terminal-notifier -title "Terminal" -message "Done with a leg"
    fi
done

wait

grep -rnw ./results_50M/ -e 'L1I LOAD' | awk '{print $1",", $4",", $8}' > results_50M/out.csv
sort -k1 -n -t, results_50M/out.csv -o results_50M/out.csv


terminal-notifier -title "Terminal" -message "Done with task! Exit status: $?"
