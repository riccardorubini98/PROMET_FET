for k in 0 1
do
    for lr in '1e-3' '5e-4' '1e-4' '5e-5' '1e-5'
    do
        for wd in '1' '10'
        do
            for d in 0.1 0.2 0.3
            do
                for act in "none" "gelu"
                do
                    EXPERIMENT_NAME="ADAPTER_"$lr"_"$wd"_"$d"_"$act
                    yq eval ".ET_Network_params.network_params.encoder_params.activation_name = \"$act\"" configs/model/classifier_promet_ada.yaml -i
                    yq eval ".ET_Network_params.network_params.encoder_params.embedding_dropout = \"$d\"" configs/model/classifier_promet_ada.yaml -i
                    yq eval ".name = \"$EXPERIMENT_NAME\"" configs/logger.yaml -i
                    bash scripts/tuning_PROMET_adapter_bart.sh -k $k -l $lr -w $wd
                done
            done
        done
    done
done
