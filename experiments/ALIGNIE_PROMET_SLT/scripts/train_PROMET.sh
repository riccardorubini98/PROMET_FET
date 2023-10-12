#!/bin/bash

CMD='python'
SEED=0
SUBSET=0
while getopts "ds:k:" opt; do
  case $opt in
    d) CMD='debugpy-run -p :5708'
    ;;
    s) SEED=$OPTARG
    ;;
    k) SUBSET=$OPTARG
    ;;
  esac
done

DATACONFIG='configs/data/few_NERD_s'$SUBSET'.yaml'

CUDA_VISIBLE_DEVICES=1 $CMD trainers/trainer_promet.py fit \
--seed_everything=$SEED \
--data configs/data/common_promet.yaml \
--data $DATACONFIG \
--trainer configs/trainer_common.yaml \
--trainer.callbacks=ModelCheckpoint \
--trainer.callbacks.dirpath= \
--trainer.callbacks.filename='PROMET' \
--trainer.callbacks.monitor=val_loss \
--trainer.callbacks.mode=min \
--trainer.callbacks.save_weights_only=True \
--model configs/model/common.yaml \
--model configs/model/classifier_promet.yaml \
--logger configs/logger.yaml \
--logger.project='PROMET_vs_ALIGNIE' \
--logger.name='PROMET_with_dropout' \
--trainer.callbacks=EarlyStopping \
--trainer.callbacks.patience=5 \
--trainer.callbacks.monitor=val_loss \
--trainer.callbacks.mode=min \
--trainer.callbacks.verbose=True \