#!/bin/bash

for lambda in '1e-3' '1e-5' '1e-7'
do
    for lr in '1e-2' '5e-3' '1e-3' '5e-4'
    do
        for k in 0 1
        do
            bash scripts/train_ALIGNIE_tuning.sh -k $k -l $lr -a $lambda
        done
    done
done    