#!/bin/bash

CMD='python'
SEED=0
SUBSET=0
LR='1E-3'
WD='1E-2'
while getopts "ds:k:l:w:" opt; do
  case $opt in
    d) CMD='debugpy-run -p :5708'
    ;;
    s) SEED=$OPTARG
    ;;
    k) SUBSET=$OPTARG
    ;;
    l) LR=$OPTARG
    ;;
    w) WD=$OPTARG
    ;;
  esac
done


DATACONFIG='configs/data/few_NERD_s'$SUBSET'.yaml'

CUDA_VISIBLE_DEVICES=1 $CMD trainers/tuning_promet.py fit \
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
--model configs/model/classifier_promet_ada.yaml \
--model.learning_rate=$LR \
--model.wd=$WD \
--logger configs/logger.yaml \
--logger.project='PROMET_ADA_TUNING' \
--trainer.callbacks=EarlyStopping \
--trainer.callbacks.patience=5 \
--trainer.callbacks.monitor=val_loss \
--trainer.callbacks.mode=min \
--trainer.callbacks.verbose=True \