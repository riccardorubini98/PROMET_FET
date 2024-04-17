
for pw in 1 2 4 8
do
    EXPERIMENT_NAME="ALIGNIE_"$pw
    yq eval ".loss_module_params.loss_params.pos_weight = \"$pw\"" configs/model/classifier_alignie.yaml -i
    yq eval ".name = \"$EXPERIMENT_NAME\"" configs/logger.yaml -i
    bash scripts/ALIGNIE_figer_tuning.sh -k 0
    bash scripts/ALIGNIE_bbn_tuning.sh -k 0
done
