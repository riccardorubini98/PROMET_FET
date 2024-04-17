
for pw in 1 2 4 8
do
    EXPERIMENT_NAME="PROMET_"$pw
    yq eval ".loss_module_params.loss_params.pos_weight = \"$pw\"" configs/model/promet_best.yaml -i
    yq eval ".loss_module_params.loss_params.pos_weight = \"$pw\"" configs/model/promet_ada_best.yaml -i
    yq eval ".name = \"$EXPERIMENT_NAME\"" configs/logger.yaml -i
    bash scripts/ada_bbn_tuning.sh -k 0
    bash scripts/ada_figer_tuning.sh -k 0
    bash scripts/noada_bbn_tuning.sh -k 0
    bash scripts/noada_figer_tuning.sh -k 0
done
