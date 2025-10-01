#!/bin/bash

while true; do
    # Get the list of jobs
    tsp -C
    tsp -l

    # Sleep for a bit before checking again
    sleep 1
    clear
done

