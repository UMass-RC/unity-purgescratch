#!/bin/bash

for node_path in /scratch/*; do
        node=$(basename $node_path)
        if [ "$node" == "login" ]; then
                echo "Skipping login node"
                continue
        fi

        [ "$(ls -A $node_path)" ] && echo "Checking node $node" || continue
        for job_path in $node_path/*; do
                job=$(basename $job_path)
                squeue -j $job > /dev/null 2>&1
                if [ $? -eq 0 ]; then
                        echo Job $job is still running, skipping
                else
                        echo Job $job is no longer running, deleting "$job_path"
                        rm -rf $job_path
                fi
        done
done
