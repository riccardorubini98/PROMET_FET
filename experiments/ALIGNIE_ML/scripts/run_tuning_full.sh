
for lr in '5e-3' '1e-3'
do
    for lambda in '1e-3' '1e-5'
    do
        for pw in 1 2 4 8
        do
            EXPERIMENT_NAME="ALIGINIE_"$lr"_"$lambda"_"$pw
            yq eval ".loss_module_params.loss_params.pos_weight = \"$pw\"" configs/model/classifier_alignie.yaml -i
            yq eval ".name = \"$EXPERIMENT_NAME\"" configs/logger.yaml -i
            bash scripts/ALIGNIE_few_nerd_tuning.sh -k 0 -l $lr -a $lambda
        done
    done
done
