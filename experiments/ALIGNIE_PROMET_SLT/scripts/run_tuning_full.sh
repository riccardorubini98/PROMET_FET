
for lr in '1e-2' '5e-3' '1e-3'
do
    for lambda in '1e-3' '1e-5' '1e-7'
        do
            EXPERIMENT_NAME="ALIGINIE_"$lr"_"$lambda
            yq eval ".name = \"$EXPERIMENT_NAME\"" configs/logger.yaml -i
            bash scripts/ALIGNIE_few_nerd_tuning.sh -k 0 -l $lr -a $lambda
    done
done
