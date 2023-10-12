#!/bin/bash

for lr in '1e-4' '5e-5' '1e-5' '5e-6' '1e-6'
do
    for k in 0 1
    do
        bash scripts/train_ALIGNIE_tuning.sh -k $k -l $lr -a 1
    done
done