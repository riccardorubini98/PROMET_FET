#!/bin/bash

for seed in 0 5 10
do
    for k in 0 1 2 3 4
    do
        bash scripts/train_ALIGNIE_30_epochs.sh -s $seed -k $k
    done
done