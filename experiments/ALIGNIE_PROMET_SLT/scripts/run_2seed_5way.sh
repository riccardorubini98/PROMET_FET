#!/bin/bash

for seed in 0 5
do
    for k in 0 1 2 3 4
    do
        bash scripts/ALIGNIE_few_nerd.sh -s $seed -k $k
    done
done