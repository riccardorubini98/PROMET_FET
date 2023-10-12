#!/bin/bash

for lambda in '1e-3' '1e-5' '1e-7'
do
    for lr in '1e-2' '5e-3' '1e-3' '5e-4'
    do
        for wd in '0.01' '0.1' '1' '10'
        do
            for k in 0 1
            do
                bash scripts/train_PROMET_tuning.sh -k $k -l $lr -a $lambda -w $wd
            done
        done
    done
done    