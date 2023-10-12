#!/bin/bash

for lr in '5e-5' '1e-5' '5e-6' '1e-6' '5e-7' '1e-7'
do
    for wd in '1e-2' '1e-1' '1' '10'
    do
        for k in 0 1
        do
            bash scripts/train_PROMET_tuning.sh -k $k -l $lr -a 1 -w $wd
        done
    done
done